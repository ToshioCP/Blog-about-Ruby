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

  def new
    @word = Word.new
    @submit = "作成"
  end

  def create
    @word = Word.new(word_params)
    if @word.save
      flash[:success] = "単語を保存しました"
      redirect_to @word, status: :see_other
    else
      flash.now[:alert] = "単語を保存できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    begin
      @word = Word.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @word = nil
      flash[:alert] = "データベースにはid=#{params[:id]}のデータは登録されていません"
      redirect_to words_path, status: :see_other
    end
    @submit = "変更"
  end

  def update
    @word = Word.find(params[:id])
    if @word.update(word_params)
      redirect_to @word, status: :see_other
    else
      flash.now[:alert] = "単語「#{@word.en}」は変更できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word = Word.find(params[:id])
    if @word == nil
      flash[:alert] = "単語#{@en}は未登録のため削除できません"
    else
      begin
        @word.destroy
      rescue
        flash[:alert] = "単語#{@en}を削除できませんでした"
      else
        flash[:success] = "単語を削除しました"
      end
      redirect_to words_path, status: :see_other
    end
  end

  def search
    @search_word = params[:search]
    if @search_word == ""
      flash.now[:alert] = "検索ワードは入力必須です"
      render html: "", status: :unprocessable_entity
    end
    begin
      pattern = Regexp.compile(@search_word)
    rescue RegexpError
      flash.now[:alert] = "正規表現に構文エラーがあります"
      render :index, status: :unprocessable_entity
    else
      @words = Word.all.select{|word| word[:en] =~ pattern}.sort{|w1,w2| w1[:en] <=> w2[:en]}
    end
  end

  private

  def word_params
    params.require(:word).permit(:en, :jp, :note)
  end
end
