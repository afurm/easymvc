require 'sqlite3'

module EasyMvc
  class Mapper
    @@db = SQLite3::Database.new File.join "db", "app.db"
    @@table_name = ""
    @@model = nil
    @@mapping = { }

    def save(model)
      @model = model
      if model.id
        @@db.execute %Q(
          UPDATE #{@@table_name}
          SET #{update_record_placeholders}
          where id = ?), update_record_values
      else
        @@db.execute "INSERT INTO #{@@table_name} (#{get_columns}) VALUES (#{new_record_placeholders})", new_record_values
      end
    end

    def new_record_placeholders
      (["?"] * (@@mapping.size - 1)).join(",")
    end

    def update_record_placeholders
      column = @@mapping.keys
      column.delete(:id)
      column.map { |col| "#{col}=?" }.join(",")
    end

    def get_values
      attributes = @@mapping.values
      attributes.delete(:id)
      attributes.map { |method| self.send(method) }
    end

    def get_columns
      column = @@mapping.keys
      column.delete(:id)
      column.join(",")
    end

    def update_record_values
      get_values << self.send(:id)
    end

    def new_record_values
      get_values
    end

    def method_missing(method, *args)
      @model.send method
    end

    def self.find(id)
      row = @@db.execute("SELECT #{@@mapping.keys.join(",")} FROM #{@@table_name} WHERE id=?", id).first
      self.map_row_to_object(row)
    end

    def self.map_row_to_object(row)
      model = @@model.new

      @@mapping.each_value.with_index do |attribute, index|
        model.send "#{attribute}=", row[index]
      end
      model
    end

    def self.find_all
      data = @@db.execute "SELECT #{@@mapping.keys.join(",")} FROM #{@@table_name}"
      data.map do |row|
        self.map_row_to_object(row)
      end
    end

    def delete(id)
      @@db.execute "DELETE FROM #{@@table_name} WHERE id=?", id
    end
  end
end
