#!/usr/bin/env ruby

# This sample application creates a simple HIT using Libraries for Amazon Web Services.

require 'ruby-aws'
@mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox

# Use this line instead if you want the production website.
#@mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production


def createNewHIT
  title = "Movie Survey"
  desc = "This is a survey to find out how many movies you have watched recently."
  keywords = "movie, survey"
  numAssignments = 100
  rewardAmount = 0.05 # 5 cents
  
  # Define the location of the externalized question (QuestionForm) file.
  rootDir = File.dirname $0
  questionFile = rootDir + "/moviesurvey.question"

  # Load the question (QuestionForm) file
  question = File.read( questionFile )
  
  result = @mturk.createHIT( :Title => title,
    :Description => desc,
    :MaxAssignments => numAssignments,
    :Reward => { :Amount => rewardAmount, :CurrencyCode => 'USD' },
    :Question => question,
    :Keywords => keywords )

  puts "Created HIT: #{result[:HITId]}"
  puts "HIT Location: #{getHITUrl( result[:HITTypeId] )}"
  return result
end

def getHITUrl( hitTypeId )
  if @mturk.host =~ /sandbox/
    "http://workersandbox.mturk.com/mturk/preview?groupId=#{hitTypeId}"   # Sandbox Url
  else
    "http://mturk.com/mturk/preview?groupId=#{hitTypeId}"   # Production Url
  end
end

createNewHIT