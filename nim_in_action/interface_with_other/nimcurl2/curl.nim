const
    libname = "libcurl.so(|.4)"

type
    Option* = enum
        OPT_PORT = 0 + 3, OPT_TIMEOUT = 0 + 13, OPT_INFILESIZE = 0 + 14,
        OPT_LOW_SPEED_LIMIT = 0 + 19, OPT_LOW_SPEED_TIME = 0 + 20,
        OPT_RESUME_FROM = 0 + 21, OPT_CRLF = 0 + 27, OPT_SSLVERSION = 0 + 32,
        OPT_TIMECONDITION = 0 + 33, OPT_TIMEVALUE = 0 + 34, OPT_VERBOSE = 0 + 41,
        OPT_HEADER = 0 + 42, OPT_NOPROGRESS = 0 + 43, OPT_NOBODY = 0 + 44,
        OPT_FAILONERROR = 0 + 45, OPT_UPLOAD = 0 + 46, OPT_POST = 0 + 47,
        OPT_FTPLISTONLY = 0 + 48, OPT_FTPAPPEND = 0 + 50, OPT_NETRC = 0 + 51,
        OPT_FOLLOWLOCATION = 0 + 52, OPT_TRANSFERTEXT = 0 + 53, OPT_PUT = 0 + 54,
        OPT_AUTOREFERER = 0 + 58, OPT_PROXYPORT = 0 + 59,
        OPT_POSTFIELDSIZE = 0 + 60, OPT_HTTPPROXYTUNNEL = 0 + 61,
        OPT_SSL_VERIFYPEER = 0 + 64, OPT_MAXREDIRS = 0 + 68, OPT_FILETIME = 0 + 69,
        OPT_MAXCONNECTS = 0 + 71, OPT_CLOSEPOLICY = 0 + 72,
        OPT_FRESH_CONNECT = 0 + 74, OPT_FORBID_REUSE = 0 + 75,
        OPT_CONNECTTIMEOUT = 0 + 78, OPT_HTTPGET = 0 + 80,
        OPT_SSL_VERIFYHOST = 0 + 81, OPT_HTTP_VERSION = 0 + 84,
        OPT_FTP_USE_EPSV = 0 + 85, OPT_SSLENGINE_DEFAULT = 0 + 90,
        OPT_DNS_USE_GLOBAL_CACHE = 0 + 91, OPT_DNS_CACHE_TIMEOUT = 0 + 92,
        OPT_COOKIESESSION = 0 + 96, OPT_BUFFERSIZE = 0 + 98, OPT_NOSIGNAL = 0 + 99,
        OPT_PROXYTYPE = 0 + 101, OPT_UNRESTRICTED_AUTH = 0 + 105,
        OPT_FTP_USE_EPRT = 0 + 106, OPT_HTTPAUTH = 0 + 107,
        OPT_FTP_CREATE_MISSING_DIRS = 0 + 110, OPT_PROXYAUTH = 0 + 111,
        OPT_FTP_RESPONSE_TIMEOUT = 0 + 112, OPT_IPRESOLVE = 0 + 113,
        OPT_MAXFILESIZE = 0 + 114, OPT_FTP_SSL = 0 + 119, OPT_TCP_NODELAY = 0 + 121,
        OPT_FTPSSLAUTH = 0 + 129, OPT_IGNORE_CONTENT_LENGTH = 0 + 136,
        OPT_FTP_SKIP_PASV_IP = 0 + 137, OPT_FTP_FILEMETHOD = 0 + 138,
        OPT_LOCALPORT = 0 + 139, OPT_LOCALPORTRANGE = 0 + 140,
        OPT_CONNECT_ONLY = 0 + 141, OPT_FILE = 10000 + 1, OPT_URL = 10000 + 2,
        OPT_PROXY = 10000 + 4, OPT_USERPWD = 10000 + 5,
        OPT_PROXYUSERPWD = 10000 + 6, OPT_RANGE = 10000 + 7, OPT_INFILE = 10000 + 9,
        OPT_ERRORBUFFER = 10000 + 10, OPT_POSTFIELDS = 10000 + 15,
        OPT_REFERER = 10000 + 16, OPT_FTPPORT = 10000 + 17,
        OPT_USERAGENT = 10000 + 18, OPT_COOKIE = 10000 + 22,
        OPT_HTTPHEADER = 10000 + 23, OPT_HTTPPOST = 10000 + 24,
        OPT_SSLCERT = 10000 + 25, OPT_SSLCERTPASSWD = 10000 + 26,
        OPT_QUOTE = 10000 + 28, OPT_WRITEHEADER = 10000 + 29,
        OPT_COOKIEFILE = 10000 + 31, OPT_CUSTOMREQUEST = 10000 + 36,
        OPT_STDERR = 10000 + 37, OPT_POSTQUOTE = 10000 + 39,
        OPT_WRITEINFO = 10000 + 40, OPT_PROGRESSDATA = 10000 + 57,
        OPT_INTERFACE = 10000 + 62, OPT_KRB4LEVEL = 10000 + 63,
        OPT_CAINFO = 10000 + 65, OPT_TELNETOPTIONS = 10000 + 70,
        OPT_RANDOM_FILE = 10000 + 76, OPT_EGDSOCKET = 10000 + 77,
        OPT_COOKIEJAR = 10000 + 82, OPT_SSL_CIPHER_LIST = 10000 + 83,
        OPT_SSLCERTTYPE = 10000 + 86, OPT_SSLKEY = 10000 + 87,
        OPT_SSLKEYTYPE = 10000 + 88, OPT_SSLENGINE = 10000 + 89,
        OPT_PREQUOTE = 10000 + 93, OPT_DEBUGDATA = 10000 + 95,
        OPT_CAPATH = 10000 + 97, OPT_SHARE = 10000 + 100,
        OPT_ENCODING = 10000 + 102, OPT_PRIVATE = 10000 + 103,
        OPT_HTTP200ALIASES = 10000 + 104, OPT_SSL_CTX_DATA = 10000 + 109,
        OPT_NETRC_FILE = 10000 + 118, OPT_SOURCE_USERPWD = 10000 + 123,
        OPT_SOURCE_PREQUOTE = 10000 + 127, OPT_SOURCE_POSTQUOTE = 10000 + 128,
        OPT_IOCTLDATA = 10000 + 131, OPT_SOURCE_URL = 10000 + 132,
        OPT_SOURCE_QUOTE = 10000 + 133, OPT_FTP_ACCOUNT = 10000 + 134,
        OPT_COOKIELIST = 10000 + 135, OPT_FTP_ALTERNATIVE_TO_USER = 10000 + 147,
        OPT_LASTENTRY = 10000 + 148, OPT_USERNAME = 10000 + 173,
        OPT_PASSWORD = 10000 + 174, OPT_UNIX_SOCKET_PATH = 10000 + 231
        OPT_MIMEPOST = 10000 + 269, OPT_WRITEFUNCTION = 20000 + 11,
        OPT_READFUNCTION = 20000 + 12, OPT_PROGRESSFUNCTION = 20000 + 56,
        OPT_HEADERFUNCTION = 20000 + 79, OPT_DEBUGFUNCTION = 20000 + 94,
        OPT_SSL_CTX_FUNCTION = 20000 + 108, OPT_IOCTLFUNCTION = 20000 + 130,
        OPT_CONV_FROM_NETWORK_FUNCTION = 20000 + 142,
        OPT_CONV_TO_NETWORK_FUNCTION = 20000 + 143,
        OPT_CONV_FROM_UTF8_FUNCTION = 20000 + 144,
        OPT_INFILESIZE_LARGE = 30000 + 115, OPT_RESUME_FROM_LARGE = 30000 + 116,
        OPT_MAXFILESIZE_LARGE = 30000 + 117, OPT_POSTFIELDSIZE_LARGE = 30000 + 120,
        OPT_MAX_SEND_SPEED_LARGE = 30000 + 145,
        OPT_MAX_RECV_SPEED_LARGE = 30000 + 146
    Code* = enum
        E_OK = 0, E_UNSUPPORTED_PROTOCOL, E_FAILED_INIT, E_URL_MALFORMAT,
        E_URL_MALFORMAT_USER, E_COULDNT_RESOLVE_PROXY, E_COULDNT_RESOLVE_HOST,
        E_COULDNT_CONNECT, E_FTP_WEIRD_SERVER_REPLY, E_FTP_ACCESS_DENIED,
        E_FTP_USER_PASSWORD_INCORRECT, E_FTP_WEIRD_PASS_REPLY,
        E_FTP_WEIRD_USER_REPLY, E_FTP_WEIRD_PASV_REPLY, E_FTP_WEIRD_227_FORMAT,
        E_FTP_CANT_GET_HOST, E_FTP_CANT_RECONNECT, E_FTP_COULDNT_SET_BINARY,
        E_PARTIAL_FILE, E_FTP_COULDNT_RETR_FILE, E_FTP_WRITE_ERROR,
        E_FTP_QUOTE_ERROR, E_HTTP_RETURNED_ERROR, E_WRITE_ERROR, E_MALFORMAT_USER,
        E_FTP_COULDNT_STOR_FILE, E_READ_ERROR, E_OUT_OF_MEMORY,
        E_OPERATION_TIMEOUTED, E_FTP_COULDNT_SET_ASCII, E_FTP_PORT_FAILED,
        E_FTP_COULDNT_USE_REST, E_FTP_COULDNT_GET_SIZE, E_HTTP_RANGE_ERROR,
        E_HTTP_POST_ERROR, E_SSL_CONNECT_ERROR, E_BAD_DOWNLOAD_RESUME,
        E_FILE_COULDNT_READ_FILE, E_LDAP_CANNOT_BIND, E_LDAP_SEARCH_FAILED,
        E_LIBRARY_NOT_FOUND, E_FUNCTION_NOT_FOUND, E_ABORTED_BY_CALLBACK,
        E_BAD_FUNCTION_ARGUMENT, E_BAD_CALLING_ORDER, E_INTERFACE_FAILED,
        E_BAD_PASSWORD_ENTERED, E_TOO_MANY_REDIRECTS, E_UNKNOWN_TELNET_OPTION,
        E_TELNET_OPTION_SYNTAX, E_OBSOLETE, E_SSL_PEER_CERTIFICATE, E_GOT_NOTHING,
        E_SSL_ENGINE_NOTFOUND, E_SSL_ENGINE_SETFAILED, E_SEND_ERROR, E_RECV_ERROR,
        E_SHARE_IN_USE, E_SSL_CERTPROBLEM, E_SSL_CIPHER, E_SSL_CACERT,
        E_BAD_CONTENT_ENCODING, E_LDAP_INVALID_URL, E_FILESIZE_EXCEEDED,
        E_FTP_SSL_FAILED, E_SEND_FAIL_REWIND, E_SSL_ENGINE_INITFAILED,
        E_LOGIN_DENIED, E_TFTP_NOTFOUND, E_TFTP_PERM, E_TFTP_DISKFULL,
        E_TFTP_ILLEGAL, E_TFTP_UNKNOWNID, E_TFTP_EXISTS, E_TFTP_NOSUCHUSER,
        E_CONV_FAILED, E_CONV_REQD, LAST
    Poption* = ptr Option
    PCurl* = ptr Curl
    Curl* = pointer
    
const
    OPT_WRITEDATA* = OPT_FILE

proc easy_init*(): PCurl{.cdecl, dynlib: libname, importc: "curl_easy_init".}
proc easy_setopt*(curl: PCurl, option: Option): Code{.cdecl, varargs, dynlib: libname,
    importc: "curl_easy_setopt".}
proc easy_perform*(curl: PCurl): Code{.cdecl, dynlib: libname,
                                importc: "curl_easy_perform".}
proc easy_cleanup*(curl: PCurl){.cdecl, dynlib: libname, importc: "curl_easy_cleanup".}