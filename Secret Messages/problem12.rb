ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
DICTIONARY_FILE = 'dic.txt'
CIPHER_FILE = 'complex_cipher.txt'
OUTPUT_FILE = 'output.txt'

class CaesarCipher

  def initialize shift
    alpha1 = ALPHABET.split ''
    alpha2 = ALPHABET.split ''
    @alphabet = Hash.new
    for i in 0...shift do
      alpha2.push alpha2.shift
    end
    for i in 0...alpha1.length do
      @alphabet[alpha2[i]] = alpha1[i]
	end
  end
  
  def [] letter
    @alphabet[letter]
  end
  
  def decode word
    word_a = word.split ''
	res = Array.new
	word_a.each do |letter|
      if ! self[letter]
        res.push letter
      else
        res.push self[letter]
      end		
	end
	return res.join ''
  end

end

# load dictionary
dictionary = nil
File.open DICTIONARY_FILE, 'rb' do |file|
  dictionary = file.read.split "\r\n"
end

# load cipher
key = cipher = nil
file = File.open CIPHER_FILE, 'rb'

# get cipher key
key = file.readline
key = /[A-Z]+/.match(key).to_s

# get cipher text
file.readline
cipher = file.read.to_s.split ''

# decodes cipher key
for i in 0...ALPHABET.length do
  c = CaesarCipher.new i
  decoded = c.decode key
  key = decoded if dictionary.index { |word| word.eql? decoded }
end

# create corresponding caesar ciphers
caesar_a = Array.new
aux_a = ALPHABET.split ''
key_a = key.split ''
key_a.each do |letter|
  caesar_a.push CaesarCipher.new aux_a.index { |l| l.eql? letter }
end

# decipher text
index = 0
result = Array.new
cipher.each do |letter|
  if ! caesar_a[index][letter]
    result.push letter
  else
    result.push caesar_a[index][letter]
	index += 1
	index = 0 if index >= caesar_a.length
  end
end

# output result
File.open OUTPUT_FILE, 'w' do |file|
  file.puts result.join ''
end




































