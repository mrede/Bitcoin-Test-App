$ ->
  set_example = (value, output) ->   

    # Update example field
    amt_field = parseFloat($('#amount').val())
    if amt_field == NaN
      amt_field = 0

    #round = amt_field.toFixed(value-1)
    round = Math.ceil(amt_field * (10**(value)))
    round = round / (10**value)

    console.log("VALUE",output, value, amt_field, round)
    $('.example').text("("+round+") "+output)

  $('#ex1').slider formatter: (value) ->
    
    switch value 
      when 1 then output = "Nearest 1 BTC"
      when 2 then output = "Nearest 1 dBTC"
      when 3 then output = "Nearest 1 cBtc"
      when 4 then output = "Nearest 100 mBtc"
      when 5 then output = "Nearest 10 mBtc"
      when 6 then output = "Nearest 1 mBtc"
      when 7 then output = "Nearest 1 Finney"

    set_example(value, output)
    return output
 
  
  
    
