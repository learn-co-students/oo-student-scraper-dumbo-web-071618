require 'open-uri'
require 'pry'


class Scraper
  
  # student_cards: doc.css('.roster-cards-container')
  # name: student.css('h4.student-name').text
  # location: student.css('p.student-location').text
  # profile_url: student.css('a').attribute("href").value
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css('.student-card')

    student_cards.map do |student|
      {
        name: student.css('h4.student-name').text,
        location: student.css('p.student-location').text,
        profile_url: student.css('a').attribute("href").value
      }
    end
  end

  # twitter: student_profile.css('div.social-icon-container a:first-child').attribute('href').text
  # linkedin: student_profile.css('div.social-icon-container a:nth-child(2)').attribute('href').text
  # github: student_profile.css('div.social-icon-container a:nth-child(3)').attribute('href').text
  # blog: student_profile.css('div.social-icon-container a:nth-child(4)').attribute('href').text
  # profile_quote: student_profile.css('div.profile-quote').text
  # bio: student_profile.css('div.bio-content.content-holder div.description-holder p').text
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_profile = doc.css('.main-wrapper')

    social_media = {
      profile_quote: student_profile.css('div.profile-quote').text,
      bio: student_profile.css('div.bio-content.content-holder div.description-holder p').text
    }
    
    #TODO: change to work with regex so it can account for any website
    student_profile.css('div.social-icon-container a').each do |anchor|
      social_media_url = anchor.attribute('href').text
      case 
      when social_media_url.include?('twitter')
        social_media[:twitter] = social_media_url
      when social_media_url.include?('github')
        social_media[:github] = social_media_url
      when social_media_url.include?('linkedin')
        social_media[:linkedin] = social_media_url
      when social_media_url.include?('http')
        social_media[:blog] = social_media_url
      end
    end
    social_media
  end
end

