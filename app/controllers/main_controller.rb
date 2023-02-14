require 'open-uri'

class MainController < ApplicationController
  def index
    contents = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQinSfIXxix7J5JOnJwy8WbTdUdN2ldhedaXys0YVUidk39a7p9X3a-sbTJRJn5yBcTqPWmr0qMferQ/pub?gid=0&single=true&output=csv').read
    pp contents.to_json
  end
end
