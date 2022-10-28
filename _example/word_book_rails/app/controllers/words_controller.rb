class WordsController < ApplicationController
  def index
  end

  def show
    begin
      @word = Word.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @word = nil
      flash.now[:alert] = "データベースにはid=#{params[:id]}のデータは登録されていません"
    end
  end    

  def append
    @en = @jp = ""
    set_append
  end

  def create
    @en = params[:word][:en]
    @jp = params[:word][:jp]
    @word = Word.new(en: @en, jp: @jp)
    if @word.save
      flash[:success] = "単語を保存しました"
      redirect_to "/words/show/#{@word.id}", status: :see_other
    else
      set_append
      flash.now[:alert] = "単語を保存できませんでした"
      render :append, status: :unprocessable_entity
    end
  end

  def change
    @en = @jp = ""
    set_change
  end

  def update
    @en = params[:word][:en]
    @jp = params[:word][:jp]
    @word = Word.find_by(en: @en)
    if @word == nil
      set_change
      flash.now[:alert] = "単語「#{@en}」は未登録のため変更できません"
      render :change, status: :unprocessable_entity
    elsif @word.update jp: @jp
      flash[:success] = "単語を変更しました"
      redirect_to "/words/show/#{@word.id}", status: :see_other
    else
      set_change
      flash.now[:alert] = "変更した単語を保存できませんでした"
      render :change, status: :unprocessable_entity
    end
  end

  def delete
    @delete_word = ""
  end

  def exec_delete
    @delete_word = params[:en]
    @word = Word.find_by(en: @delete_word)
    if @word == nil
      flash.now[:alert] = "単語#{@en}は未登録のため削除できません"
      render :delete, status: :unprocessable_entity
    else
      begin
        @word.destroy
      rescue
        flash[:alert] = "単語#{@en}を削除できませんでした"
      else
        flash[:success] = "単語を削除しました"
      end
      redirect_to words_index_path, status: :see_other
    end
  end

  def search
    @search_word = ""
  end

  def list
    @search_word = params[:en]
    if @search_word == ""
      flash.now[:alert] = "検索ワードは入力必須です"
      render :search, status: :unprocessable_entity
    end
    begin
      pattern = Regexp.compile(@search_word)
    rescue RegexpError
      flash.now[:alert] = "正規表現に構文エラーがあります"
      render :search, status: :unprocessable_entity
    else
      @words = Word.all.select{|word| word[:en] =~ pattern}.sort{|w1,w2| w1[:en] <=> w2[:en]}
    end
  end

  private

  def set_append
    @word = Word.new unless @word
    @path = words_create_path
    @submit = "作成"
  end
  def set_change
    @word = Word.new unless @word
    @path = words_update_path
    @submit = "変更"
  end
end
