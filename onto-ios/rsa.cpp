// rsa.cpp
// g++ rsa.cpp -o rsa -lcrypto & ./rsa
#include "rsa.h"

static string Sha256(const char *data, bool bHex = true) {
  unsigned char md[SHA256_DIGEST_LENGTH] = {0};

  SHA256((const unsigned char *)data, strlen(data), md);
  if (!bHex) {
    string s;
    s.resize(SHA256_DIGEST_LENGTH);
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
      s[i] = md[i];
    }
    return s;
  } else {
    string s;
    s.resize(SHA256_DIGEST_LENGTH * 2);
    int k = 0;
    for (unsigned int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
      sprintf(&s.at(k), "%02x", md[i]);
      k += 2;
    }
    return s;
  }
}

// bool GenStrKey(const int kBits, const int kExp,
//                const std::string &PubPemFileName,
//                const std::string &PriPemFileNam) {
//   char *pri_pem_key;
//   char *pub_pem_key;

//   RSA *rsa = RSA_generate_key(kBits, kExp, 0, 0);

//   /* To get the C-string PEM form: */
//   BIO *pri_bio = BIO_new(BIO_s_mem());
//   BIO *pub_bio = BIO_new(BIO_s_mem());
//   PEM_write_bio_RSAPrivateKey(pri_bio, rsa, NULL, NULL, 0, NULL, NULL);
//   PEM_write_bio_RSAPublicKey(pub_bio, rsa);

//   int pri_key_len = BIO_pending(pri_bio);
//   int pub_key_len = BIO_pending(pub_bio);
//   /* Null-terminate */
//   pri_pem_key = static_cast<char *>(calloc(pri_key_len + 1, 1));
//   pub_pem_key = static_cast<char *>(calloc(pub_key_len + 1, 1));

//   BIO_read(pri_bio, pri_pem_key, pri_key_len);
//   BIO_read(pub_bio, pub_pem_key, pub_key_len);

//   BIO *pri_bio_file = BIO_new_file("prikey.pem", "w");
//   if (!pri_bio_file) {
//     return false;
//   }
//   /* Write the key to disk. */
//   if (!PEM_write_bio_RSAPrivateKey(pri_bio_file, rsa, NULL, NULL, 0, NULL,
//                                    NULL)) {
//     return false;
//   }
//   BIO_free_all(pri_bio_file);

//   BIO *pub_bio_file = BIO_new_file("pubkey.pem", "w");
//   if (!pub_bio_file) {
//     return false;
//   }
//   /* Write the key to disk. */
//   if (!PEM_write_bio_RSAPrivateKey(pub_bio_file, rsa, NULL, NULL, 0, NULL,
//                                    NULL)) {
//     return false;
//   }
//   BIO_free_all(pub_bio_file);

//   BIO_free_all(pri_bio);
//   BIO_free_all(pub_bio);
//   RSA_free(rsa);
//   free(pri_pem_key);
//   free(pub_pem_key);
//   return true;
// }

bool Rsa::KeyGen(const int kBits, const int kExp,
                 const std::string &PubPemFileName,
                 const std::string &PriPemFileName) {

  RSA *rsa = RSA_generate_key(kBits, kExp, 0, 0);

  /* Write the key to disk. */
  FILE *hPriKeyFile = fopen(PriPemFileName.c_str(), "wb");
  if (hPriKeyFile == NULL) {
    return false;
  }
  if (!PEM_write_RSAPrivateKey(hPriKeyFile, rsa, NULL, NULL, 0, NULL, NULL)) {
    return false;
  }
  fclose(hPriKeyFile);

  /* Write the key to disk. */
  FILE *hPubKeyFile = fopen(PubPemFileName.c_str(), "wb");
  if (hPubKeyFile == NULL) {
    return false;
  }
  if (!PEM_write_RSAPublicKey(hPubKeyFile, rsa)) {
    return false;
  }
  fclose(hPubKeyFile);

  RSA_free(rsa);
  return true;
}

bool Rsa::RsaPubPemEnc(const std::string &strData, std::string &strRet,
                       const std::string &strPemFileName) {
  if (strPemFileName.empty() || strData.empty()) {
    return false;
  }
  FILE *hPubKeyFile = fopen(strPemFileName.c_str(), "rb");
  if (hPubKeyFile == NULL) {
    return false;
  }
  RSA *pRSAPubKey = RSA_new();

  if (PEM_read_RSAPublicKey(hPubKeyFile, &pRSAPubKey, NULL, NULL) == NULL) {
    return false;
  }

  int nLen = RSA_size(pRSAPubKey);
  char *pEncode = new char[nLen + 1];
  int ret = RSA_public_encrypt(
      strData.length(), (const unsigned char *)strData.c_str(),
      (unsigned char *)pEncode, pRSAPubKey, RSA_PKCS1_PADDING);
  if (ret >= 0) {
    strRet = std::string(pEncode, ret);
  }
  delete[] pEncode;
  RSA_free(pRSAPubKey);
  fclose(hPubKeyFile);
  CRYPTO_cleanup_all_ex_data();
  return true;
}

bool Rsa::RsaPriPemDec(const std::string &strData, std::string &strRet,
                       const std::string &strPemFileName) {
  if (strPemFileName.empty() || strData.empty()) {
    return false;
  }
  FILE *hPriKeyFile = fopen(strPemFileName.c_str(), "rb");
  if (hPriKeyFile == NULL) {
    return false;
  }
  RSA *pRSAPriKey = RSA_new();

  if (PEM_read_RSAPrivateKey(hPriKeyFile, &pRSAPriKey, NULL, NULL) == NULL) {
    return false;
  }
  int nLen = RSA_size(pRSAPriKey);
  char *pDecode = new char[nLen + 1];

  int ret = RSA_private_decrypt(
      strData.length(), (const unsigned char *)strData.c_str(),
      (unsigned char *)pDecode, pRSAPriKey, RSA_PKCS1_PADDING);
  if (ret >= 0) {
    strRet = std::string((char *)pDecode, ret);
  }
  delete[] pDecode;
  RSA_free(pRSAPriKey);
  fclose(hPriKeyFile);
  CRYPTO_cleanup_all_ex_data();
  return true;
}

void Rsa::RsaSign(const std::string &msg, std::string &sign_digest,
                  int hash_type) {
  string digest;
  // SHA256
  if (hash_type == 0) {
    digest = Sha256(msg.c_str());
    RsaPriPemDec(digest, sign_digest);
  }
}

bool Rsa::RsaVeri(const std::string &msg, const std::string &sign_digest,
                  int hash_type) {
  string digest, veri_digest;
  // SHA256
  if (hash_type == 0) {
    digest = Sha256(msg.c_str());
  }
  RsaPubPemEnc(sign_digest, veri_digest);
  if (sign_digest != veri_digest) {
    return false;
  } else {
    return true;
  }
}