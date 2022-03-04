import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:crypt/crypt.dart';

class CryptUtil {

  static String charset = "UTF-8";
  static String secretId = "AKIDwkIbeQvA8pFOHuJTN1PXOzIK5aolRqyp";
  static String secretKey = "bw1pNefPr2xbx2rPggPs4vWqtfAOL1QY";

  static String getSignString(){
    // 1644995135171008
    // 1644995168777
    // 1644995846
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(0,10);

    Map<String, Object> params = {
      "Nonce": Random().nextInt(100000),
      "Timestamp":timestamp,
      "SecretId":secretId,
      "Action":"DescribeInstances",
      "Version" : "2017-03-12",
      "Region" : "ap-guangzhou",
      "Limit":20,
      "Offset" : 0,
      "InstanceIds.0":"ins-09dx96dg",
    };
    List attrKeys = params.keys.toList();
    attrKeys.sort();
    String ss = getStringToSign(params,attrKeys);
    String signature = sign(ss, secretKey);
    print("ss = $ss;\nsignature = $signature");
    params["Signature"] = signature;
    print("getUrl(params) = ${getUrl(params)}");
    return getUrl(params);
  }

  static String sign(String s, String k){
    var key = utf8.encode(k);
    var bytes = utf8.encode(s);
    Hmac hmac = Hmac(sha1, key);
    Digest sha1Result = hmac.convert(bytes);
    var signStr = base64Encode(sha1Result.bytes);
    return signStr;
  }

  static String getStringToSign(Map<String, Object> params, List attrKeys){
    String s2s = "GETcvm.tencentcloudapi.com/?";
    // s2s = "GEThttps://service-1neqmc80-1257701204.gz.apigw.tencentcs.com/release/helloworld-1644989722129/?";
    attrKeys.forEach((key) {
      s2s += key + "=" + params[key].toString() + "&";
    });
    return s2s.substring(0, s2s.length - 1);
  }

  static String getUrl(Map<String, Object> params){
    String url = "https://cvm.tencentcloudapi.com/?";
    // url = "https://service-1neqmc80-1257701204.gz.apigw.tencentcs.com/release/helloworld-1644989722129/?";
    params.forEach((key, value) {
      url += key + "=" + Uri.encodeComponent(value.toString()) + "&";
      // url += key + "=" + value.toString() + "&";
    });
    return url.substring(0, url.length - 1);
  }
}