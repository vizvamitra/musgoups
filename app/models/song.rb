class Song < ActiveRecord::Base
	belongs_to :group

	validates :title, presence: true
	validates :group_id, presence: true

	def self.get_one(id)
		result = Song.find_by_sql("SELECT * FROM songs
		                           WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_group_id(id)
		Song.find_by_sql("SELECT * FROM songs
			 								WHERE group_id = #{id}")
	end

	def save
		if self.title == ''
      self.errors.add(:title, "Необходимо указать имя")
    	false
    else
      query = "INSERT INTO songs (title,
                                  music_by,
                                  lyrics_by,
                                  group_id,
                                  created_at, 
                                	updated_at)
               VALUES ('#{title}',
                       '#{music_by}',
                       '#{lyrics_by}',
                        #{group_id},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}')"
			begin
      	ActiveRecord::Base.connection.execute(query)
        true
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end
    end
	end

	def update(new_data)
		if new_data['title'] == ''
			self.errors.add(:title, "Необходимо указать имя")
    	false
		else
  		query = "UPDATE songs
               SET title = '#{new_data['title']}',
                   music_by = '#{new_data['music_by']}',
                   lyrics_by = '#{new_data['lyrics_by']}',
                   updated_at = '#{Time.now.to_s(:db)}'
               WHERE id=#{id};"
      begin
      	ActiveRecord::Base.connection.execute(query)
        true
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
      	false
      end
    end
	end

	def delete
		query = "DELETE FROM songs WHERE id = #{id}"
		begin
    	ActiveRecord::Base.connection.execute(query)
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end
end
