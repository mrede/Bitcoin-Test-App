$ ->
  # Shows example rounding
  set_example = (value, output) ->   

    # Update example field
    amt_field = parseFloat($('#amount').val())
    if isNaN(amt_field)
      return

    #round = amt_field.toFixed(value-1)
    round = Math.ceil(amt_field * (10**(value)))
    round = (round / (10**value)).toFixed(value)

    # console.log("VALUE",output, value, amt_field, round)
    $('.example').text("("+round+") "+output)

  get_example_text = (value) ->
    value = parseInt(value)
    switch value 
      
      when 1 then output = "Nearest 1 dBTC"
      when 2 then output = "Nearest 1 cBtc"
      when 3 then output = "Nearest 1 mBtc"
      when 4 then output = "Nearest 100 μBtc"
      when 5 then output = "Nearest 10 μBtc"
      when 6 then output = "Nearest 1 μBtc"
      when 7 then output = "Nearest 1 Finney"
    return output

  $('#ex1').slider formatter: (value) ->
    
    set_example(value, get_example_text(value))
    return get_example_text(value)
 
  # Detech change on amount
  $('#amount').on('change', ->
    
    value = $('#ex1').val()
    set_example(value, get_example_text(value))
  )
  
    
