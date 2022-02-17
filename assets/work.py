import requests

con = {
  'Afghanistan': 'AF',
  'Albania': 'AL',
  'Algeria': 'DZ',
  'American Samoa': 'AS',
  'Andorra': 'AD',
  'Angola': 'AO',
  'Anguilla': 'AI',
  'Antigua & Barbuda': 'AG',
  'Argentina': 'AR',
  'Armenia': 'AM',
  'Aruba': 'AW',
  'Australia': 'AUSTRALIAN',
  'Austria': 'AUSTRIAN',
  'Azerbaijan': 'AZ',
  'Bahamas': 'BS',
  'Bahrain': 'BH',
  'Bangladesh': 'BD',
  'Barbados': 'BB',
  'Belarus': 'BY',
  'Belgium': 'BE',
  'Belize': 'BZ',
  'Benin': 'BJ',
  'Bermuda': 'BM',
  'Bhutan': 'BT',
  'Bolivia': 'BO',
  'Bosnia & Herzegovina': 'BA',
  'Botswana': 'BW',
  'Brazil': 'BRAZILIAN',
  'British Virgin Islands': 'VG',
  'Brunei': 'BN',
  'Bulgaria': 'BULGARIAN',
  'Burkina Faso': 'BF',
  'Burundi': 'BI',
  'Cambodia': 'KH',
  'Cameroon': 'CM',
  'Canada': 'CANADIAN',
  'Cape Verde': 'CV',
  'Cayman Islands': 'KY',
  'Central African Republic': 'CF',
  'Chad': 'TD',
  'Chile': 'CL',
  'China': 'CHINA',
  'Colombia': 'CO',
  'Comoros': 'KM',
  'Congo - Brazzaville': 'CG',
  'Congo - Kinshasa': 'CD',
  'Cook Islands': 'CK',
  'Costa Rica': 'CR',
  'Cote d\'Ivoire': 'CI',
  'Croatia': 'CROATIAN',
  'Cuba': 'CU',
  'Curacao': 'CW',
  'Cyprus': 'CY',
  'Czechia': 'CZECH',
  'Denmark': 'DANISH',
  'Djibouti': 'DJ',
  'Dominica': 'DM',
  'Dominican Republic': 'DO',
  'Ecuador': 'EC',
  'Egypt': 'EG',
  'El Salvador': 'SV',
  'Equatorial Guinea': 'GQ',
  'Eritrea': 'ER',
  'Estonia': 'EE',
  'Eswatini': 'SZ',
  'Ethiopia': 'ET',
  'Falkland Islands': 'FK',
  'Faroe Islands': 'FO',
  'Fiji': 'FJ',
  'Finland': 'FINNISH',
  'France': 'FRENCH',
  'French Guiana': 'GF',
  'French Polynesia': 'PF',
  'Gabon': 'GA',
  'Gambia': 'GM',
  'Georgia': 'GE',
  'Germany': 'GERMAN',
  'Ghana': 'GH',
  'Gibraltar': 'GI',
  'Greece': 'GREEK',
  'Greenland': 'GL',
  'Grenada': 'GD',
  'Guadeloupe': 'GP',
  'Guam': 'GU',
  'Guatemala': 'GT',
  'Guernsey': 'GG',
  'Guinea': 'GN',
  'Guinea-Bissau': 'GW',
  'Guyana': 'GY',
  'Haiti': 'HT',
  'Honduras': 'HN',
  'Hong Kong': 'HONG_KONG',
  'Hungary': 'HUNGARIAN',
  'Iceland': 'IS',
  'India': 'INDIAN',
  'Indonesia': 'INDONESIAN',
  'Iran': 'IR',
  'Iraq': 'IQ',
  'Ireland': 'IRISH',
  'Isle of Man': 'IM',
  'Israel': 'JEWISH',
  'Italy': 'ITALIAN',
  'Jamaica': 'JM',
  'Japan': 'JAPANESE',
  'Jersey': 'JE',
  'Jordan': 'JO',
  'Kazakhstan': 'KZ',
  'Kenya': 'KE',
  'Kiribati': 'KI',
  'Kosovo': 'XK',
  'Kuwait': 'KW',
  'Kyrgyzstan': 'KG',
  'Laos': 'LA',
  'Latvia': 'LATVIAN',
  'Lebanon': 'LB',
  'Lesotho': 'LS',
  'Liberia': 'LR',
  'Libya': 'LY',
  'Liechtenstein': 'LI',
  'Lithuania': 'LITHUANIAN',
  'Luxembourg': 'LU',
  'Macao': 'MO',
  'Madagascar': 'MG',
  'Malawi': 'MW',
  'Malaysia': 'MALAYSIA',
  'Maldives': 'MV',
  'Mali': 'ML',
  'Malta': 'MT',
  'Marshall Islands': 'MH',
  'Martinique': 'MQ',
  'Mauritania': 'MR',
  'Mauritius': 'MU',
  'Mayotte': 'YT',
  'Mexico': 'MEXICAN',
  'Micronesia': 'FM',
  'Moldova': 'MD',
  'Monaco': 'MC',
  'Mongolia': 'MN',
  'Montenegro': 'ME',
  'Montserrat': 'MS',
  'Morocco': 'MA',
  'Mozambique': 'MZ',
  'Myanmar (Burma)': 'MM',
  'Namibia': 'NA',
  'Nauru': 'NR',
  'Nepal': 'NP',
  'Netherlands': 'DUTCH',
  'New Caledonia': 'NC',
  'New Zealand': 'NEW_ZEALAND',
  'Nicaragua': 'NI',
  'Niger': 'NE',
  'Nigeria': 'NG',
  'North Korea': 'KP',
  'North Macedonia': 'MK',
  'Northern Mariana Islands': 'MP',
  'Norway': 'NORWEGIAN',
  'Oman': 'OM',
  'Pakistan': 'PK',
  'Palau': 'PW',
  'Panama': 'PA',
  'Papua New Guinea': 'PG',
  'Paraguay': 'PY',
  'Peru': 'PE',
  'Philippines': 'PHILIPPINES',
  'Poland': 'POLISH',
  'Portugal': 'PORTUGUESE',
  'Puerto Rico': 'PR',
  'Qatar': 'QA',
  'Réunion': 'RE',
  'Romania': 'ROMANIAN',
  'Russia': 'RUSSIAN',
  'Rwanda': 'RW',
  'Samoa': 'WS',
  'San Marino': 'SM',
  'São Tomé & Príncipe': 'ST',
  'Saudi Arabia': 'SAUDIARABIAN',
  'Senegal': 'SN',
  'Serbia': 'RS',
  'Seychelles': 'SC',
  'Sierra Leone': 'SL',
  'Singapore': 'SINGAPORE',
  'Sint Maarten': 'SX',
  'Slovakia': 'SLOVAK',
  'Slovenia': 'SLOVENIAN',
  'Solomon Islands': 'SB',
  'Somalia': 'SO',
  'South Africa': 'SA',
  'South Korea': 'SOUTH_KOREA',
  'South Sudan': 'SS',
  'Spain': 'SPAIN',
  'Sri Lanka': 'LK',
  'St. Barthélemy': 'BL',
  'St. Helena': 'SH',
  'St. Kitts and Nevis': 'KN',
  'St. Lucia': 'LC',
  'St. Martin': 'MF',
  'St. Pierre & Miquelon': 'PM',
  'St. Vincent & Grenadines': 'VC',
  'Sudan': 'SD',
  'Suriname': 'SR',
  'Sweden': 'SWEDISH',
  'Switzerland': 'CH',
  'Syria': 'SY',
  'Taiwan': 'TAIWAN',
  'Tajikistan': 'TJ',
  'Tanzania': 'TZ',
  'Thailand': 'TH',
  'Timor-Leste': 'TL',
  'Togo': 'TG',
  'Tonga': 'TO',
  'Trinidad and Tobago': 'TT',
  'Tunisia': 'TN',
  'Turkey': 'TURKISH',
  'Turkmenistan': 'TM',
  'Turks and Caicos Islands': 'TC',
  'Tuvalu': 'TV',
  'U.S. Virgin Islands': 'VI',
  'Uganda': 'UG',
  'Ukraine': 'UKRAINIAN',
  'United Arab Emirates': 'AE',
  'United Kingdom': 'UK',
  'United States': 'USA',
  'Uruguay': 'UY',
  'Uzbekistan': 'UZ',
  'Vanuatu': 'VU',
  'Vatican City': 'VA',
  'Venezuela': 'VE',
  'Vietnam': 'VIETNAMESE',
  'Wallis and Futuna': 'WF',
  'Yemen': 'YE',
  'Zambia': 'ZM',
  'Zimbabwe': 'ZW',
}

#for i in con.keys():
 #   json = requests.get(f'https://kgsearch.googleapis.com/v1/entities:search?key=AIzaSyDnbWgAujTw2tkFxANKJZ5dD8XrnevXS1I&limit=1&query={i}+Flag').json()
 #   try:
 #     link = json['itemListElement'][0]['result']['image']['contentUrl']
  #    r = requests.get(link)
  #    file = open(f"{i}.png", "wb")
   #   file.write(r.content)
    #  file.close()
   # except:
    #  print(i)


con2 = ['Anguilla',
'Armenia',
'Aruba',
'Bermuda',
'British Virgin Islands',
'Cayman Islands',
'Colombia',
'Congo - Brazzaville',
'Congo - Kinshasa',
'Czechia',
'Eritrea',
'Falkland Islands',
'Faroe Islands',
'French Polynesia',
'Gibraltar',
'Greece',
'Greenland',
'Guadeloupe',
'Guam',
'Guatemala',
'Iraq',
'Kazakhstan',
'Kiribati',
'Kosovo',
'Liechtenstein',
'Macao',
'Martinique',
'Mauritania',
'Mayotte',
'Myanmar (Burma)',
'New Caledonia',
'Panama',
'Portugal',
'Réunion',
'Sint Maarten',
'St. Barthélemy',
'St. Martin',
'U.S. Virgin Islands',
'Wallis and Futuna']




#for i in con2:
#    if '&' in i:
#        x = i.replace('&', 'and')
#    else:
#        x = i
#
#    if 'St.' in x:
#        x = x.replace('St.', 'Saint')
#
#    json = requests.get(f'https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=pageimages&piprop=original&titles=flag of {x}').json()
#    try:
#        link = json['query']['pages'][0]['original']['source'] #query.pages[0].original.source
#        r = requests.get(link)
#        file = open(f"{i}.svg", "wb")
#        file.write(r.content)
#        file.close()
#    except:
#        print(i)

for i in con3:
    if '&' in i:
        x = i.replace('&', 'and')
    else:
        x = i

    if 'St.' in x:
        x = x.replace('St.', 'Saint')

    json = requests.get(f'https://kgsearch.googleapis.com/v1/entities:search?key=AIzaSyDnbWgAujTw2tkFxANKJZ5dD8XrnevXS1I&limit=1&query={x}').json()
    try:
        link = json['itemListElement'][0]['result']['image']['contentUrl']
        r = requests.get(link)
        file = open(f"{i}.png", "wb")
        file.write(r.content)
        file.close()
    except:
      print(i)
