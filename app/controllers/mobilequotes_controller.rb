class MobilequotesController < ApplicationController
 

  # Connects up TextMagic Service to the URL
  def connect
  end

  # Create new route between user mobile and Quotes Service ( new and create methods )
  def new
  end

 
  def create

    puts ""
    puts "Executing Phone Route Creation Action "
    puts ""
   
    require 'textmagic'
    
    #Set up instance variables
    @forename = params[:forename]
    @lastname = params[:lastname]
    @mobile_no = params[:mobile_no]

    puts "Connecting Phone No."
    puts @mobile_no  
    puts ""


    # Set TextMagic usercode and password and send message
    api = TextMagic::API.new("mcgournj","1dkmJ4QUcBItZ6e")
    api.send "Welcome "+@forename+", Mobile Stock Quotes now available - send request now!",@mobile_no

    flash[:notice] = "Phone Link Created!"
    redirect_to :action => "new"
  end



  # Retrieves quote and returns it to user mobile through TextMagic service.
  def show
    
 
    # Set instance variables 
    if params[:text].nil? 
      @quote_list = ""
    else
      @quote_list = params[:text]    
    end
    if params[:from].nil?
      @callback_no = ""
    else
      @callback_no = params[:from]
    end
    @quote_info = ""


    # Tracking progress and status
    puts ""
    puts "Executing the Show Action"
    puts ""
    puts "Stock Symbol:"
    puts @quote_list
    puts ""
    puts "Phone no:"
    puts @callback_no
    puts ""

   
    # Loading Libraries
    require 'yahoofinance'
    require 'textmagic'

   

    # Set usercode and password for TextMagic
    api = TextMagic::API.new("mcgournj","1dkmJ4QUcBItZ6e")
    

    # Set the type of quote we want to retrieve.
    # Available type are:
    #  - YahooFinance::StandardQuote
    #  - YahooFinance::ExtendedQuote
    #  - YahooFinance::RealTimeQuote
    quote_type = YahooFinance::StandardQuote


    # Set the symbols for which we want to retrieve quotes.
    # You can include more than one symbol by separating 
    # them with a ',' (comma).
    quote_symbols = @quote_list
   
    

    # Get the quotes from Yahoo! Finance.  The get_quotes method call
    # returns a Hash containing one quote object of type "quote_type" for
    # each symbol in "quote_symbols".  If a block is given, it will be
    # called with the quote object (as in the example below).
    # YahooFinance::get_quotes( quote_type, quote_symbols ) do |qt| 

    @quote_info = YahooFinance::get_quotes( quote_type, quote_symbols ) do |stock|
      puts stock.to_s
      api.send "Price quoted for     "+stock.symbol+" Bid: "+stock.bid.to_s+"  Ask: "+stock.ask.to_s, @callback_no
    end

    # redirect_to :action => "new"
   end

end
