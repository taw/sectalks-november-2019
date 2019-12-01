#!/usr/bin/env python
"""
Decryption Engine
"""

from Crypto.Cipher import AES
from datetime import datetime
import sys

def decrypt(filename, passphrase):
    if not passphrase:
        passphrase = datetime.strftime(datetime.now(), 'Current Time: %H%M hours')
    try:
        cipher_text = open(filename, 'rb').read()
    except IOError:
        print "Error: File does not exist."
        return
    print AES.new(passphrase, AES.MODE_CBC, 'FDK184481HGBBRVS').decrypt(cipher_text)

if __name__ == "__main__":
    if len(sys.argv) > 3 or len(sys.argv) == 1:
        print "Usage: ./decrypt <filename> <passphrase>"
        sys.exit(2)
    if len(sys.argv) == 2:
        passphrase = ''
    else:
        passphrase = sys.argv[2]
    decrypt(sys.argv[1], passphrase)