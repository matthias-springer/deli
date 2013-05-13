Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| Kernel.require file }
