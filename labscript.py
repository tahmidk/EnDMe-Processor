# All Possible full-length tap patterns for 8-bits
taps = [0xe1, 0xd4, 0xc6, 0xb8, 0xb4, 0xb2, 0xfa, 0xf3]

# The message
message = "Mr. Watson, come here. I want to see you."
message_bin = [ord(' ') for i in range(0, 9)]  # Guaranteed atleast 9 spaces

p = 2
  
  
# -----------------------Prepare the message-----------------------
def preamble_gen(size):
  ''' Append a preamble of [size] spaces in message_bin
  '''
  for i in range(0, size):
    message_bin.append(ord(' '))

def message_gen():
  ''' Convert message to binary and put them in message_bin. Fill in remaining
      space with binary spaces ' ' until we have 64 bytes/characters
  '''
  for letter in message:
    message_bin.append(ord(letter))
  
  while(len(message_bin) < 64):
    message_bin.append(ord(' '))

preamble_gen(p)
message_gen()


# --------------------------Encryption--------------------------
def encrypt(seed, tap, m):
  encoding = ""         # The return value
  lfsr_state = seed     # The seed is the 1st state of the lfsr sequence
  
  for i in range(0, 64):  # There are 64 characters to encrypt, spaces included
    #print("{0:08b}".format(lfsr_state), end='\t')
    # This part of the code generates the next state of the lfsr
    temp = lfsr_state & tap           # 0 out non-tap bits and preserve the tap bits
    temp = temp ^ (temp >> 4)         # XOR all 8 bits in temp together using divide and conquer
    temp = temp ^ (temp >> 2)
    temp = temp ^ (temp >> 1)         # Now LSB represents temp[0]^temp[1]^...^temp[7] (parity bit)
    parity_bit = temp & 0x1           # Extract parity bit
    
    lfsr_state = lfsr_state << 1      # shift current state over by 1 to make room for parity bit
    lfsr_state += parity_bit          # Incorporate parity bit into new state
    lfsr_state = lfsr_state & 255     # Keep only lower 8 bits
    
    # This part of the code gets the encoding of character i of message_bin
    enc = lfsr_state ^ m[i]       # This is the encrypted character
    encoding += chr(enc)
  
  return encoding

encryption = encrypt(0x03, taps[7], message_bin)
print("--------------[Encryption:]--------------\n%s" % encryption)


# --------------------------Decryption----------------------------
def find_tap_and_seed(encryption):
  seed1 = ord(' ') ^ ord(encryption[0])    # seed1 is the 2nd state of the lfsr 
  #print("{0:08b}".format(seed1))
  for pattern in taps:
    # Derive the initial lsfr state seed0 given the pattern
    parity_bit = seed1 & 0x1
    possibility = seed1 >> 1
    temp = possibility & pattern      # 0 out non-tap bits and preserve the tap bits
    temp = temp ^ (temp >> 4)         # XOR all 8 bits in temp together using divide and conquer
    temp = temp ^ (temp >> 2)
    temp = temp ^ (temp >> 1)         # Now LSB represents temp[0]^temp[1]^...^temp[7] (parity bit)
    if parity_bit == (temp & 0x1):    # Compare parity bits. If same, then possibility is seed0 
      my_seed = possibility
    else:
      my_seed = possibility + 0x80    # Otherwise soln is the other possiblity (MSB 1 instead of 0)

    # Check whether the encoding of 8 spaces matches encryption
    encoding = encrypt(my_seed, pattern, message_bin)
    if encoding == encryption:
      return (pattern, my_seed)

  print("No taps found")
  return None


def decrypt(seed, tap, enc):
  decoding = ""         # The return value
  lfsr_state = seed     # The seed is the 1st state of the lfsr sequence
  
  for i in range(0, 64):  # There are 64 characters to encrypt, spaces included
    #print("{0:08b}".format(lfsr_state), end='\t')
    # This part of the code generates the next state of the lfsr
    temp = lfsr_state & tap           # 0 out non-tap bits and preserve the tap bits
    temp = temp ^ (temp >> 4)         # XOR all 8 bits in temp together using divide and conquer
    temp = temp ^ (temp >> 2)
    temp = temp ^ (temp >> 1)         # Now LSB represents temp[0]^temp[1]^...^temp[7] (parity bit)
    parity_bit = temp & 0x1           # Extract parity bit
    
    lfsr_state = lfsr_state << 1      # shift current state over by 1 to make room for parity bit
    lfsr_state += parity_bit          # Incorporate parity bit into new state
    lfsr_state = lfsr_state & 255     # Keep only lower 8 bits
    
    if i < (9 + p):           # Skip decoding preamble spaces
      continue
    if i > 41 + (9 + p):      # Skip decoding postamble spaces
      break

    # This part of the code gets the decoding of character i of enc
    dec = lfsr_state ^ enc[i]       # This is the decrypted character
    decoding += chr(dec)
  
  return decoding

(tap_pattern, seed) = find_tap_and_seed(encryption)

encryption_bin = [ord(letter) for letter in encryption]
decryption = decrypt(seed, tap_pattern, encryption_bin)


print("\n--------------[Decryption]--------------")
print("[Tap Pattern:]\t %s" % "{0:08b}".format(tap_pattern))
print("[Seed:]\t\t %s" % "{0:08b}".format(seed))
print("[Decryption:]\t %s" % str(decryption))