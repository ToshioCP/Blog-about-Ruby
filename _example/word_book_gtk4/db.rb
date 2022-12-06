require "gtk4"
require "csv"
require "singleton"

# WBRecord (wordbook record) is a class of the record of the database (DB class)
# It has three strings -- en, jp and note.
# They need to be properties of this object because they are reffered with GtkExpression's property expressions from GtkColumnView.
# (The property expressions are lookup tags in UI files.)

class WBRecord < GLib::Object
  type_register
  def initialize(*record)
    super()
    if record.size == 1 && record[0].instance_of?(Array)
      record = record[0]
    end
    unless record[0].instance_of?(String) && record[1].instance_of?(String) && record[2].instance_of?(String)
      record = ["", "", ""]
    end
    set_property("en", record[0])
    set_property("jp", record[1])
    set_property("note", record[2])
  end
  def to_a
    [en, jp, note]
  end
  install_property(GLib::Param::String.new("en", # name
    "en", # nick
    "English", # blurb
    "",     # default value
    GLib::Param::READWRITE # flag
    )
  )
  install_property(GLib::Param::String.new("jp", # name
    "jp", # nick
    "Japanese", # blurb
    "",     # default value
    GLib::Param::READWRITE # flag
    )
  )
  install_property(GLib::Param::String.new("note", # name
    "note", # nick
    "Notes of the English word", # blurb
    "",     # default value
    GLib::Param::READWRITE # flag
    )
  )
  private
  def en=(e); @en=e; end
  def jp=(j); @jp=j; end
  def note=(n); @note=n; end
  def en; @en; end
  def jp; @jp; end
  def note; @note; end
end

# DB is a wrapper class of GListStore.
# The GListStore object is created in advance when the UI file is read by GtkBuilder.
# So, the DB instance doesn't have a GListStore at its creation.
# The GListStore object will be added later.
# And it won't be changed once it is added.

class DB
  include Singleton
  def init (file='db.csv', liststore)
    return if @file # Initialization is only once.
    @file = file
    @liststore = liststore
    if File.exist?(@file)
      CSV.read(@file, headers: false).each do |record|
        @liststore.append(WBRecord.new(record))
      end
    end
  end
  def liststore
    @liststore
  end
  def record(index)
    @liststore.get_item(index).to_a
  end
  def append(record)
    @liststore.append(WBRecord.new(record))
  end
  
  def delete(index)
    @liststore.remove(index)
  end
  def change(index,record)
    @liststore.remove(index)
    @liststore.insert(index,WBRecord.new(record))
  end
  def close
    CSV.open(@file, "wb") do |csv|
      n = @liststore.n_items
      0.upto(n-1) do |index|
        csv << @liststore.get_item(index).to_a
      end
    end
  end
end
