SAMPLE_COUNT = 170
SLEEP_HOURS_GAP = 3 
cities = [
  {name:'London', flag:true},
  {name:'Bristol', flag:true},
  {name:'Liverpool', flag:true},
  {name:'Glasgow', flag:false},
  {name:'Oxford', flag:false}
]
$effectivenesses = [0, 50, 80, 100]
$ages = [(1..10), (11..22), (23..35), (36..55), (56..80), (81..90)]
def generate_line(city, age_range, gender, flag = false)
  sleep_hours = Faker::Number.between(from: 1, to: 10)
  effectiveness = nil
  if flag
    coin = Faker::Number.between(from: 1, to: 10) <= 8
    if coin && (sleep_hours <= SLEEP_HOURS_GAP && age_range == $ages[4] || age_range == $ages[5])
      effectiveness = $effectivenesses[0]
    end
  end
  if effectiveness.nil?
    effectiveness = $effectivenesses[Faker::Number.between(from: 0, to: ($effectivenesses.count - 1))]
  end
  [
    Faker::Name.name, # NAME
    Faker::Number.between(from: age_range.first, to: age_range.last),  # AGE
    sleep_hours, # SLEEP HOURS
    Faker::IDNumber.valid, # ID NUMBER
    gender, # GENDER
    effectiveness, #EFFECTIVENESS
    city, # CITY
  ].join(';')
end
headers = "NAME;AGE;SLEEPHOURS;IDNUMBER;GENDER;EFFECTIVENESS;CITY"
result = []
cities.each do |city|
  $ages.each do |age_range|
    ['F', 'M'].each{ |g| SAMPLE_COUNT.times{ result << generate_line(city[:name], age_range, g, city[:flag]) } }
  end
end
result.shuffle!
result.unshift headers
File.write('dataset.csv', result.join("\n"))
