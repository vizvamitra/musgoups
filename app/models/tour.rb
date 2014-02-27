class Tour < ActiveRecord::Base
	belongs_to :group
	has_many :concerts, dependent: :destroy

  # attr_accessor :begin_date, :end_date

	def self.get_one(id)
		result = Tour.find_by_sql("SELECT * FROM tours
		                            WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_group_id(id)
    Tour.find_by_sql("SELECT
                        t.id, t.title, t.group_id, d.begin_date, d.end_date
                      FROM
                        tours t
                      INNER JOIN
                        ( SELECT MIN(date) AS begin_date,
                                 MAX(date) AS end_date,
                                 tour_id
                         FROM concerts
                         GROUP BY tour_id
                        ) d ON t.id = d.tour_id
                      WHERE t.group_id=#{id}")
  end

  def get_concerts
    query = "SELECT * FROM concerts
             WHERE tour_id = #{id}
             ORDER BY date ASC"
    begin
      ActiveRecord::Base.connection.execute(query)
    rescue => e
      self.errors[:base] << "Произошла ошибка"
      nil
    end
  end

	def save
		if self.title == ''
      self.errors.add(:title, "Необходимо указать название")
    	false
    else
      query = "INSERT INTO tours (title,
                                  group_id,
                                  created_at, 
                                  updated_at)
               VALUES ('#{title}',
                        #{group_id},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}');"
			begin
      	self.id = ActiveRecord::Base.connection.insert(query)
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end
    end
	end

	def update(new_data)
		if new_data['title'] == ''
			self.errors.add(:title, "Необходимо указать название")
    	false
		else
  		query = "UPDATE tours
               SET title = '#{new_data['title']}',
                   group_id = #{new_data['group_id']},
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
    begin
      query = "DELETE FROM concerts WHERE tour_id=#{id};"
      ActiveRecord::Base.connection.execute(query)

      query = "DELETE FROM tours WHERE id=#{id};"
      ActiveRecord::Base.connection.execute(query)
      
      true
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end
end
