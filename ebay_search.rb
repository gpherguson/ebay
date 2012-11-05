#!/usr/bin/env ruby -w

require 'rubygems'
require 'addressable/uri'
require 'nokogiri'
require 'open-uri'

SANDBOX_KEYS = {
  :DevID  => '4d084c1a-0499-4f6b-ae1a-36ac5f7a2c62',
  :AppID  => 'GregFerg-f246-4b70-b2f5-5b1ee770444a',
  :CertID => '90e1ea85-16e1-407a-a8c5-8c99c7fa60c5'
}

PRODUCTION_KEYS = {
  :DevID  => '4d084c1a-0499-4f6b-ae1a-36ac5f7a2c62',
  :AppID  => 'GregFerg-978e-41b2-9b05-989dd0306554',
  :CertID => '51dc2d17-8de4-436e-b0c5-c1091b4bf37f'
}

# Formats: XML, SOAP, Name Value, JSON
#
# Protocols: HTTP GET and POST
#
# APIs supported
#
# getSearchKeywordsRecommendation : Get recommended keywords for search
# findItemsByKeywords             : Search items by keywords
# findItemsByCategory             : Search items in a category
# findItemsAdvanced               : Advanced search capabilities
# findItemsByProduct              : Search items by a product identifier
# findItemsIneBayStores           : Search items in stores
# getHistograms                   : Get category and domain meta data
URL = 'http://svcs.ebay.com/services/search/FindingService/v1'
PARMS = {
  'OPERATION-NAME'                 => 'findItemsByKeywords',
  'SERVICE-VERSION'                => '1.0.0',
  'SECURITY-APPNAME'               => SANDBOX_KEYS[:AppID],
  'RESPONSE-DATA-FORMAT'           => 'JSON',
  'REST-PAYLOAD'                   => nil,
  'paginationInput.entriesPerPage' => '10'
}

uri               = Addressable::URI.parse(URL)
query             = PARMS
query['keywords'] = ARGV.join(' ')
uri.query_values  = query

json = open(URL).read
