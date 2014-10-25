$(->

  # Constants
  ONE_DAY = 1000 * 60 * 60 * 24

  # Initizize country list
  window.initCountryList = ->
    $countrySelect = $('#country')
    optionsFrag = document.createDocumentFragment()
    
    $.each(expectancy, (index, el) ->
      country = el.country
      option = document.createElement('option')
      option.value = country
      option.innerText = country
      optionsFrag.appendChild(option)
    )

    $countrySelect.append(optionsFrag)

  window.getLifeExpectancyForCountry = (country) ->
    countries = expectancy.filter (el) -> el.country == country
    countries[0]

  # Parse date string, format: yyyy-mm-dd
  window.parseDate = (date) ->
    ymd = date.split('-')
    new Date(ymd[0], ymd[1]-1, ymd[2])

  window.getDaysLived = (birthdate) ->
    birth = parseDate(birthdate)
    now = new Date()
    Math.floor((now-birth) / ONE_DAY)

  window.getDaysToLive = (countryExpectancy, genre, daysLived) ->
    daysExpected = Math.floor(countryExpectancy[genre] * 365)
    daysExpected - daysLived

  window.calculateLifePercentage = (countryExpectancy, genre, daysLived) ->
    daysExpected = Math.floor(countryExpectancy[genre] * 365)
    parseFloat(100 - (((daysLived / daysExpected) * 100).toFixed(2)))

  window.calculateLifeStats = (genre, country, birthdate) ->
    countryExpectancy = getLifeExpectancyForCountry(country)
    daysLived = getDaysLived(birthdate)
    daysToLive = getDaysToLive(countryExpectancy, genre, daysLived)
    remainingPercent = calculateLifePercentage(countryExpectancy, genre, daysLived)

    {
      daysLived: daysLived
      daysToLive: daysToLive
      remainingPercent: remainingPercent
    }

  window.calculateLifeLeft = (ev) ->
    ev.preventDefault()

    $form = $(this)
    genre = $form.find('#genre').val()
    country = $form.find('#country').val()
    birthdate = $form.find('#birthdate').val()

    if genre.length > 0 and country.length > 0 and birthdate.length > 0
      stats = calculateLifeStats(genre, country, birthdate)
      console.log("Days lived: #{stats.daysLived}; Days to live: #{stats.daysToLive}; Life left: #{stats.remainingPercent}%")

  # Start stuff
  initCountryList()

  # Events
  $('#life-form').on('submit', calculateLifeLeft)

)