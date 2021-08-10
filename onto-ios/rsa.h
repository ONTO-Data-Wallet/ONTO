#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <openssl/sha.h>

#include <cstring>
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

class Rsa {
private:
  int KeyLen;
  bool WritePem(const std::string &strPemFileName, const std::string &PemKey);

public:
  bool KeyGen(const int kBits = 1024, const int kExp = 3,
              const std::string &PubPemFileName = "pubkey.pem",
              const std::string &PriPemFileName = "prikey.pem");
  bool RsaPubPemEnc(const std::string &strData, std::string &strRet,
                    const std::string &strPemFileName = "pubkey.pem");
  bool RsaPriPemDec(const std::string &strData, std::string &strRet,
                    const std::string &strPemFileName = "prikey.pem");
  void RsaSign(const std::string &msg, std::string &sign_digest,
               int hash_type = 0);
  bool RsaVeri(const std::string &msg, const std::string &sign_digest,
               int hash_type = 0);
};
