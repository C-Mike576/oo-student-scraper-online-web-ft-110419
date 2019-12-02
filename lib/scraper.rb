require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

 
  
  def self.scrape_index_page(index_url)
    
    student_aray = []

    doc = Nokogiri::HTML(open(index_url))
    
    person = doc.search("div.student-card")
    
    person.each do |x|
      student = {:name => "",:location => "", :profile_url=> ""}
      student[:name] = x.search(".student-name").text
      student[:location] = x.search(".student-location").text
      student[:profile_url] = x.search("a").first["href"]
      student_aray << student
    end
   student_aray
  end

  def self.scrape_profile_page(profile_url)
    details = {
      :twitter=>"", 
      :linkedin=>"", 
      :github=>"", 
      :blog=>"", 
      :profile_quote=>"", 
      :bio=> ""
    }
    doc = Nokogiri::HTML(open(profile_url))
    social = doc.search(".social-icon-container a[href]")     
    social.each do |tag|
     # binding.pry
      if tag['href'].include?("twitter")
        details[:twitter] = tag["href"] 
      elsif tag['href'].include?("linkedin")
        details[:linkedin] = tag["href"]
      elsif tag['href'].include?("github")
        details[:github] = tag["href"]
      else
        details[:blog] = tag["href"]
      end
     # binding.pry
    end

    details[:profile_quote] = doc.search(".profile-quote").text
    details[:bio] = doc.search(".description-holder").first.text.strip
    details.delete_if {|key, value| value == ""}

  details
  end

end

