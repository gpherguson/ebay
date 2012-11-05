#!/usr/bin/env ruby

require 'addressable/uri'
require 'haml'
require 'json'
require 'json/add/core'
require 'open-uri'
require 'sinatra'

KEYS = {
  :sandbox => {
    :devid  => '4d084c1a-0499-4f6b-ae1a-36ac5f7a2c62',
    :appid  => 'GregFerg-f246-4b70-b2f5-5b1ee770444a',
    :certid => '90e1ea85-16e1-407a-a8c5-8c99c7fa60c5'
  },
  :production => {
    :devid  => '4d084c1a-0499-4f6b-ae1a-36ac5f7a2c62',
    :appid  => 'GregFerg-978e-41b2-9b05-989dd0306554',
    :certid => '51dc2d17-8de4-436e-b0c5-c1091b4bf37f'
  }
}

USE_KEY = :production
ENTRIES_PER_PAGE = 100

SEARCH_ITEMS = [ 'prs 513' ]

URL = 'http://svcs.ebay.com/services/search/FindingService/v1'
QUERY = {
  # 'callback'                       => '_cb_findItemsByKeywords',
  'GLOBAL-ID'                      => 'EBAY-US',
  'OPERATION-NAME'                 => 'findItemsByKeywords',
  'paginationInput.entriesPerPage' => ENTRIES_PER_PAGE.to_s,
  'RESPONSE-DATA-FORMAT'           => 'JSON',
  'REST-PAYLOAD'                   => true,
  'SECURITY-APPNAME'               => KEYS[USE_KEY][:appid],
  'SERVICE-VERSION'                => '1.0.0'
}

class Item
  attr_accessor :title, :url

  def initialize(h)
    @title = h['title']
    @url   = h['viewItemURL']
  end
end

def search(search_item)
  uri = Addressable::URI.parse(URL)
  search_items.each do |search_item|

    msg = %Q[Searching for "#{ search_item }"...]
    puts '', msg, '-' * msg.length

    QUERY['keywords'] = search_item
    uri.query_values = QUERY

    json = open(uri).read
    begin
      ebay = JSON::parse(json)
    rescue Exception => e
      STDOUT.puts e.to_s
    end

    ebay['findItemsByKeywordsResponse'].each do |_item|
      puts Time.parse(_item['timestamp'].first).strftime('%c'), ''
      _item['searchResult'].each do |_result|
        _result['item'].each do |c|
          next if (c['title'].first =~ /\b(?:pot|knob|part)\b/i)
          puts '%s => %s' % [c['title'].first , c['viewItemURL'].first]
        end
      end
    end
  end
end

get '/' do

  @search_results = search(SEARCH_ITEMS)


  haml :index
end

__END__

@@index
!!!
%html
  %head
    %title
      
  %body
