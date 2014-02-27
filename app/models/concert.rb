class Concert < ActiveRecord::Base
	belongs_to :tour

	def self.get_one(id)
		result = Concert.find_by_sql("SELECT * FROM concerts
		                           		WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_tour_id(id)
		Concert.find_by_sql("SELECT * FROM concerts
			 									 WHERE tour_id = #{id}")
	end

	def save
		if self.date == ''
      self.errors.add(:date, "Необходимо указать дату")
    	false
    elsif self.country == ''
    	self.errors.add(:country, "Необходимо указать страну")
    	false
    else
      query = "INSERT INTO concerts (country,
	                                   city,
	                                   date,
	                                   tour_id,
	                                   created_at, 
	                                	 updated_at)
               VALUES ('#{country}',
                       '#{city}',
                       '#{date}',
                        #{tour_id},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}')"
			begin
      	ActiveRecord::Base.connection.insert(query)
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end

    	true
    end
	end

	def update(new_data)
		if new_data['date'] == ''
      self.errors.add(:date, "Необходимо указать дату")
    	false
    elsif new_data['country'] == ''
    	self.errors.add(:country, "Необходимо указать страну")
    	false
    else
			query = "UPDATE concerts
	             SET country = '#{new_data['country']}',
	                 city = '#{new_data['city']}',
	                 date = '#{new_data['date']}',
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
		query = "DELETE FROM concerts WHERE id = #{id}"
		begin
    	ActiveRecord::Base.connection.execute(query)
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end
end