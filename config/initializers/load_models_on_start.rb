Maglev.persistent do
  Dir.glob("#{Rails.root}/app/models/*.rb").sort.each { |file| require_dependency file }
end