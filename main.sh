#!/bin/bash
# Date:2019-10-02 00:00
# Author:created by zhujinhui
# wechat：zhubuhuifei
# QQ:1214542118
# Description:This script is used to batch Create or Destroy tencent cloud CVM, there are still a lot of imperfections, we hope to learn together and feedback.

func_real_release() {
 echo -e "\033[31m Start Terminating instances... \033[0m"
 func_del
 read -p "Would you like to delete all or their choice to delete The instance name is an instance of [ ${INSTANCE_NAME} ]... Please select the delete option serial number [ Default: Delete all ]: " DelOpt

 if [ -z "${DelOpt}" ];then
  echo -e "\033[31m Delete All... \033[0m"
  for ins_tmp in `tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME | grep instanceid | awk -F "\"" '{print $4}'`
  do
   tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$ins_tmp\"]"
   echo -e "\033[31m Instance [ ${ins_tmp} ] deletion complete... \033[0m"
  done

  tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME
  if [ $? -ne 0 ]; then
   echo -e "\033[5;31m No instances need to be deleted ! \033[0m"
  fi

  echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
  func_exec
  func_del_real
 fi
}

func_deploy_easy() {
 while [ 0 -eq 0 ]
 do
  echo ".................. job begin ..................."   
  func_exec
  if [ $? -ne 0 ]; then
   for i in `cat /tmp/tccli.txt`
   do
    echo $i
   done
   echo "--------------- job complete ---------------"
   echo " "
     sleep 8
     tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME | grep null
     if [ $? -ne 0 ]; then
      echo " Your instance has been created successfully...,the instance information is as follows:"
      tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME
     else
      echo " Warning: IP is [ null ], please query again through the following command :"
      echo -e "\033[31m tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME \033[0m"
     fi
   break;
  else
   echo "...............error occur, retry in 2 seconds .........."
   echo ""
   sleep 2
  fi
 done
}

func_type_instance_real() {
 echo -e "\033[31m Start Terminating instances... \033[0m"
 func_del

 if [ -z "${DelOpt}" ];then
  echo -e "\033[31m Delete All... \033[0m"
  for ins_tmp in `tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}'`
  do
   tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$ins_tmp\"]"
   echo -e "\033[31m Instance [ ${ins_tmp} ] deletion complete... \033[0m"
  done
  if [ $? -ne 0 ]; then
   echo -e "\033[5;31m No instances need to be deleted ! \033[0m"
  fi

  echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
  func_exec
  func_del_real
 else
  case $DelOpt in
   "1")
    echo -e "\033[31m Delete All... \033[0m"
    for ins_tmp in `tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}'`
    do
     tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$ins_tmp\"]"
     echo -e "\033[31m Instance [ ${ins_tmp} ] deletion complete... \033[0m"
    done
    tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime}' | grep -B 4 $INSTANCE_NAME
    if [ $? -ne 0 ]; then
     echo -e "\033[5;31m No instances need to be deleted ! \033[0m"
    fi
    echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
    func_exec
    func_del_real
    ;;
   "2")
    fun_sel_del
    ;;
   *)
   echo "\033[5;31m Your input is error! plz input agian ! \033[0m"
   func_del_real
   ;;
  esac
 fi
}
func_region() {
    echo "1. 北京"
    echo "2. 广州"
    echo "3. 上海"   
    echo "4. 深圳金融"
    echo "5. 上海金融"
    echo "6. 成都"
    echo "7. 重庆"
    echo "8. 中国香港"
    echo "9. 新加坡"   
    echo "10. 首尔"
    echo "11. 东京"
    echo "12. 孟买"
    echo "13. 曼谷"
    echo "14. 多伦多"
    echo "15. 硅谷"
    echo "16. 弗吉尼亚"
    echo "17. 法兰克福"
    echo "18. 莫斯科"
}
func_img() {
    echo "  ImgId          SystemVer"
    echo "1. img-9qabwvbn    CentOS 7.6 64位"
    echo "2. img-oikl1tzv    CentOS 7.5 64位"
    echo "3. img-8toqc6s3    CentOS 7.4 64位"
    echo "4. img-dkwyg6sr    CentOS 7.3 64位"
    echo "5. img-31tjrtph    CentOS 7.2 64位"
    echo "6. img-i5u2lkoz    CentOS 6.9 64位"
    echo "7. img-rtp44ucv    CentOS 6.9 32位"   
    echo "8. img-6ns5om13    CentOS 6.8 64位"
    echo "9. img-0hvei5hp    CoreOS 1745.5.0 64位"   
    echo "10. img-6rrx0ymd    Debian 9.0 64位"
    echo "11. img-hi93l4ht    Debian 8.2 64位"
    echo "12. img-ez7jwngr    Debian 8.2 32位"
    echo "13. img-c1y1axb9    FreeBSD 11.1 64位"   
    echo "14. img-0ytr67o7    openSUSE 42.3 64位"   
    echo "15. img-pi0ii46r    Ubuntu Server 18.04.1 LTS 64位"   
    echo "16. img-pyqx34y1    Ubuntu Server 16.04.1 LTS 64位"
    echo "17. img-8u6dn6p1    Ubuntu Server 16.04.1 LTS 32位"   
    echo "18. img-3wnd9xpl    Ubuntu Server 14.04.1 LTS 64位"   
    echo "19. img-qpxvpujt    Ubuntu Server 14.04.1 LTS 32位"
    echo "20. img-9id7emv7    Windows Server 2016 数据中心版 64位中文版"
    echo "21. img-1eckhm4t    Windows Server 2016 数据中心版 64位英文版"
    echo "22. img-2tddq003    Windows Server 2012 R2 数据中心版 64位英文版"
    echo "23. img-29hl923v    Windows Server 2012 R2 数据中心版 64位中文版"
    echo "24. img-0vbqvzfn    Windows Server 2008 R2 企业版 SP1 64位"
    echo "25. img-b1ve77s9    CentOS 7.0 64位"
    echo "26. img-mv100ns3    CentOS 6.8 32位"
    echo "27. img-7fwdvfur    CentOS 6.5 64位"
    echo "28. img-hdt9xxkt    Tencent Linux release 2.4 (Final)"
    echo "29. img-feqctcrx    Debian 7.8 64位"
}

func_cbs() {
    echo "数据盘类型"
    echo "1. LOCAL_BASIC  本地硬盘"
    echo "2. LOCAL_SSD  本地SSD硬盘"
    echo "3. CLOUD_BASIC  普通云硬盘"
    echo "4. CLOUD_PREMIUM  高性能云硬盘"
    echo "5. CLOUD_SSD  SSD云硬盘"
}

func_instancetype() {
    echo "1. 标准型 S5"
    echo "2. 标准型 S4"
    echo "3. 标准网络优化型 SN3ne"
    echo "4. 标准型 S3"
    echo "5. 标准型 S2"
    echo "6. 标准型 SA1"
    echo "7. 标准网络优化型 S2ne"
    echo "8. 标准型 S1"
    echo "9. 内存型 M5"
    echo "10. 内存型 M4"
    echo "11. 内存型 M3"
    echo "12. 内存型 M2"
    echo "13. 内存型 M1"
    echo "14. 高IO型 IT3"
    echo "15. 大数据型 D2"
    echo "16. 计算型 CN3"
    echo "17. 计算型 C3"
    echo "18. 计算型 C2"
    echo "19. 批量计算型 BC1"
    echo "20. 批量计算型 BS1"
}
func_S5() {
    echo "规格    vCPU    内存 （GB）    网络收发包 (pps)    队列数    内网带宽能力 （Gbps）    主频    备注"
    echo "1. S5.SMALL1    1    1    25万    1    1.5    2.5 GHz    -"
    echo "2. S5.SMALL2    1    2    25万    1    1.5    2.5 GHz    -"
    echo "3. S5.SMALL4    1    4    25万    1    1.5    2.5 GHz    -"
    echo "4. S5.MEDIUM4    2    4    30万    2    1.5    2.5 GHz    -"
    echo "5. S5.MEDIUM8    2    8    30万    2    1.5    2.5 GHz    -"
    echo "6. S5.LARGE8    4    8    50万    2    2.0    2.5 GHz    -"
    echo "7. S5.LARGE16    4    16    50万    2    2.0    2.5 GHz    -"
    echo "8. S5.2XLARGE16    8    16    80万    2    3.0    2.5 GHz    -"
    echo "9. S5.2XLARGE32    8    32    80万    2    3.0    2.5 GHz    -"
    echo "10. S5.4XLARGE32    16    32    150万    4    6.0    2.5 GHz    -"
    echo "11. S5.4XLARGE64    16    64    150万    4    6.0    2.5 GHz    -"
    echo "12. S5.6XLARGE48    24    48    200万    6    9.0    2.5 GHz    -"
    echo "13. S5.6XLARGE96    24    96    200万    6    9.0    2.5 GHz    -"
    echo "14. S5.8XLARGE64    32    64    250万    8    12.0    2.5 GHz    -"
    echo "15. S5.8XLARGE128    32    128    250万    8    12.0    2.5 GHz    -"
    echo "16. S5.12XLARGE96    48    96    400万    12    17.0    2.5 GHz    -"
    echo "17. S5.12XLARGE192    48    192    400万    12    17.0    2.5 GHz    -"
    echo "18. S5.16XLARGE256    64    256    500万    16    23.0    2.5 GHz    -"
}

func_S4() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. S4.SMALL2    1    2    25万    1    1.5    2.4 GHz    -"
    echo "2. S4.MEDIUM4    2    4    30万    2    1.5    2.4 GHz    -"
    echo "3. S4.MEDIUM8    2    8    30万    2    1.5    2.4 GHz    -"
    echo "4. S4.LARGE8    4    8    50万    2    1.5    2.4 GHz    -"
    echo "5. S4.LARGE16    4    16    50万    2    1.5    2.4 GHz    -"
    echo "6. S4.2XLARGE16    8    16    80万    2    3.0    2.4 GHz    -"
    echo "7. S4.2XLARGE32    8    32    80万    2    3.0    2.4 GHz    -"
    echo "8. S4.4XLARGE32    16    32    150万    4    6.0    2.4 GHz    -"
    echo "9. S4.4XLARGE64    16    64    150万    4    6.0    2.4 GHz    -"
    echo "10. S4.6XLARGE48    24    48    200万    6    8.0    2.4 GHz    -"
    echo "11. S4.6XLARGE96    24    96    200万    6    8.0    2.4 GHz    -"
    echo "12. S4.8XLARGE64    32    64    250万    8    11.0    2.4 GHz    -"
    echo "13. S4.8XLARGE128    32    128    250万    8    11.0    2.4 GHz    -"
    echo "14. S4.12XLARGE96    48    96    400万    12    16.0    2.4 GHz    -"
    echo "15. S4.12XLARGE192    48    192    400万    12    16.0    2.4 GHz    -"
    echo "16. S4.16XLARGE128    64    128    500万    16    22.0    2.4 GHz    -"
    echo "17. S4.16XLARGE256    64    256    500万    16    22.0    2.4 GHz    -"
    echo "18. S4.18XLARGE288    72    288    600万    16    24.0    2.4 GHz    -"
}

func_SN3ne() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. SN3ne.SMALL2    1    2    25万    1    1.5    2.5 GHz    -"
    echo "2. SN3ne.MEDIUM4    2    4    30万    2    1.5    2.5 GHz    -"
    echo "3. SN3ne.LARGE8    4    8    50万    2    1.5    2.5 GHz    -"
    echo "4. SN3ne.LARGE16    4    16    50万    2    1.5    2.5 GHz    -"
    echo "5. SN3ne.2XLARGE16    8    16    80万    2    3.0    2.5 GHz    -"
    echo "6. SN3ne.2XLARGE32    8    32    80万    2    3.0    2.5 GHz    -"
    echo "7. SN3ne.3XLARGE24    12    24    100万    3    4.0    2.5 GHz    -"
    echo "8. SN3ne.4XLARGE32    16    32    150万    4    6.0    2.5 GHz    -"
    echo "9. SN3ne.4XLARGE64    16    64    150万    4    6.0    2.5 GHz    -"
    echo "10. SN3ne.6XLARGE48    24    48    200万    6    8.0    2.5 GHz    -"
    echo "11. SN3ne.6XLARGE96    24    96    200万    6    8.0    2.5 GHz    -"
    echo "12. SN3ne.8XLARGE64    32    64    250万    8    11.0    2.5 GHz    -"
    echo "13. SN3ne.8XLARGE128    32    128    250万    8    11.0    2.5 GHz    -"
    echo "14. SN3ne.12XLARGE96    48    96    400万    12    16.0    2.5 GHz    -"
    echo "15. SN3ne.12XLARGE192    48    192    400万    12    16.0    2.5 GHz    -"
    echo "16. SN3ne.16XLARGE128    64    128    500万    16    22.0    2.5 GHz    -"
    echo "17. SN3ne.16XLARGE256    64    256    500万    16    22.0    2.5 GHz    -"
    echo "18. SN3ne.18XLARGE288    72    288    600万    16    24.0    2.5 GHz    -"
}

func_S3() {
    echo "规格    vCPU    内存(GB)    网络收发包(pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. S3.SMALL1    1    1    20万    1    1.5    2.5 GHz    -"
    echo "2. S3.SMALL2    1    2    20万    1    1.5    2.5 GHz    -"
    echo "3. S3.SMALL4    1    4    20万    1    1.5    2.5 GHz    -"
    echo "4. S3.MEDIUM4    2    4    25万    2    1.5    2.5 GHz    -"
    echo "5. S3.MEDIUM8    2    8    25万    2    1.5    2.5 GHz    -"
    echo "6. S3.LARGE8    4    8    45万    4    1.5    2.5 GHz    -"
    echo "7. S3.LARGE16    4    16    45万    4    1.5    2.5 GHz    -"
    echo "8. S3.2XLARGE16    8    16    85万    8    1.5    2.5 GHz    -"
    echo "9. S3.2XLARGE32    8    32    85万    8    1.5    2.5 GHz    -"
    echo "10. S3.3XLARGE48    12    48    85万    12    1.5    2.5 GHz    -"
    echo "11. S3.4XLARGE32    16    32    85万    16    2.0    2.5 GHz    -"
    echo "12. S3.4XLARGE64    16    64    85万    16    2.0    2.5 GHz    -"
    echo "13. S3.6XLARGE48    24    48    85万    16    3.0    2.5 GHz    -"
    echo "14. S3.6XLARGE96    24    96    85万    16    3.0    2.5 GHz    -"
    echo "15. S3.8XLARGE64    32    64    85万    16    4.0    2.5 GHz    -"
    echo "16. S3.8XLARGE128    32    128    85万    16    4.0    2.5 GHz    -"
    echo "17. S3.12XLARGE96    48    96    85万    16    6.0    2.5 GHz    -"
    echo "18. S3.12XLARGE192    48    192    85万    16    6.0    2.5 GHz    -"
    echo "19. S3.16XLARGE128    64    128    85万    16    8.0    2.5 GHz    -"
    echo "20. S3.16XLARGE256    64    256    85万    16    8.0    2.5 GHz    -"
    echo "21. S3.20XLARGE320    80    320    85万    16    10.0    2.5 GHz    -"
}

func_S2() {
    echo "规格    vCPU    内存(GB)    网络收发包(pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. S2.SMALL1    1    1    20万    1    1.5    2.4 GHz    -"
    echo "2. S2.SMALL2    1    2    20万    1    1.5    2.4 GHz    -"
    echo "3. S2.SMALL4    1    4    20万    1    1.5    2.4 GHz    -"
    echo "4. S2.MEDIUM2    2    2    25万    2    1.5    2.4 GHz    -"
    echo "5. S2.MEDIUM4    2    4    25万    2    1.5    2.4 GHz    -"
    echo "6. S2.MEDIUM8    2    8    25万    2    1.5    2.4 GHz    -"
    echo "7. S2.LARGE8    4    8    45万    4    1.5    2.4 GHz    -"
    echo "8. S2.LARGE16    4    16    45万    4    1.5    2.4 GHz    -"
    echo "9. S2.2XLARGE16    8    16    50万    8    1.5    2.4 GHz    -"
    echo "10. S2.2XLARGE32    8    32    50万    8    1.5    2.4 GHz    -"
    echo "11. S2.3XLARGE24    12    24    50万    8    2.5    2.4 GHz    -"
    echo "12. S2.3XLARGE48    12    48    50万    8    2.5    2.4 GHz    -"
    echo "13. S2.4XLARGE32    16    32    50万    8    3.0    2.4 GHz    -"
    echo "14. S2.4XLARGE48    16    48    50万    8    3.0    2.4 GHz    -"
    echo "15. S2.4XLARGE64    16    64    50万    8    3.0    2.4 GHz    -"
    echo "16. S2.6XLARGE48    24    48    70万    8    4.5    2.4 GHz    -"
    echo "17. S2.6XLARGE96    24    96    70万    8    4.5    2.4 GHz    -"
    echo "18. S2.8XLARGE64    32    64    70万    8    6.0    2.4 GHz    -"
    echo "19. S2.8XLARGE128    32    128    70万    8    6.0    2.4 GHz    -"
    echo "20. S2.14XLARGE224    56    224    70万    8    10.0    2.4 GHz    -"
}

func_SA1() {
    echo "规格    vCPU    内存(GB)    网络收发包(pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. SA1.SMALL1    1    1    -    1    1.5    2.0 GHz    -"
    echo "2. SA1.SMALL2    1    2    -    1    1.5    2.0 GHz    -"
    echo "3. SA1.SMALL4    1    4    -    1    1.5    2.0 GHz    -"
    echo "4. SA1.MEDIUM4    2    4    -    2    1.5    2.0 GHz    -"
    echo "5. SA1.MEDIUM8    2    8    -    2    1.5    2.0 GHz    -"
    echo "6. SA1.LARGE8    4    8    -    4    1.5    2.0 GHz    -"
    echo "7. SA1.LARGE16    4    16    -    4    1.5    2.0 GHz    -"
    echo "8. SA1.2XLARGE16    8    16    -    8    1.5    2.0 GHz    -"
    echo "9. SA1.2XLARGE32    8    32    -    8    1.5    2.0 GHz    -"
    echo "10. SA1.4XLARGE32    16    32    -    16    1.5    2.0 GHz    -"
    echo "11. SA1.4XLARGE64    16    64    -    16    1.5    2.0 GHz    -"
}

func_S2ne() {
    echo "规格    vCPU    内存(GB)    网络收发包(pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. S2ne.SMALL2    1    2    8万    1    1.5    2.4 GHz    -"
    echo "2. S2ne.MEDIUM4    2    4    15万    2    1.5    2.4 GHz    -"
    echo "3. S2ne.LARGE8    4    8    30万    2    1.5    2.4 GHz    -"
    echo "4. S2ne.LARGE16    4    16    50万    2    1.5    2.4 GHz    -"
    echo "5. S2ne.2XLARGE16    8    16    60万    2    2.0    2.4 GHz    -"
    echo "6. S2ne.2XLARGE32    8    32    60万    2    2.0    2.4 GHz    -"
    echo "7. S2ne.3XLARGE24    12    24    90万    3    2.5    2.4 GHz    -"
    echo "8. S2ne.3XLARGE48    12    48    90万    3    2.5    2.4 GHz    -"
    echo "9. S2ne.4XLARGE32    16    32    120万    4    3.5    2.4 GHz    -"
    echo "10. S2ne.4XLARGE64    16    64    120万    4    3.5    2.4 GHz    -"
    echo "11. S2ne.6XLARGE48    24    48    180万    6    5.0    2.4 GHz    -"
    echo "12. S2ne.6XLARGE96    24    96    180万    6    5.0    2.4 GHz    -"
    echo "13. S2ne.8XLARGE64    32    64    240万    8    6.5    2.4 GHz    -"
    echo "14. S2ne.8XLARGE128    32    128    240万    8    6.5    2.4 GHz    -"
    echo "15. S2ne.12XLARGE192    48    192    360万    12    9.5    2.4 GHz    -"
}

func_S1() {
    echo "规格    vCPU    内存(GB)    网络收发包(pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. S1.SMALL1    1    1    -    1    1.5    -    -"
    echo "2. S1.SMALL2    1    2    -    1    1.5    -    -"
    echo "3. S1.SMALL4    1    4    -    1    1.5    -    -"
    echo "4. S1.MEDIUM2    2    2    -    2    1.5    -    -"
    echo "5. S1.MEDIUM4    2    4    -    2    1.5    -    -"
    echo "6. S1.MEDIUM8    2    8    -    2    1.5    -    -"
    echo "7. S1.MEDIUM12    2    12    -    2    1.5    -    -"
    echo "8. S1.LARGE4    4    4    -    4    1.5    -    -"
    echo "9. S1.LARGE8    4    8    -    4    1.5    -    -"
    echo "10. S1.LARGE16    4    16    -    4    1.5    -    -"
    echo "11. S1.2XLARGE8    8    8    -    8    2.0    -    -"
    echo "12. S1.2XLARGE16    8    16    -    8    2.0    -    -"
    echo "13. S1.2XLARGE32    8    32    -    8    2.0    -    -"
    echo "14. S1.3XLARGE24    12    24    -    8    2.5    -    -"
    echo "15. S1.3XLARGE48    12    48    -    8    2.5    -    -"
    echo "16. S1.4XLARGE16    16    16    -    8    3.5    -    -"
    echo "17. S1.4XLARGE32    16    32    -    8    3.5    -    -"
    echo "18. S1.4XLARGE48    16    48    -    8    3.5    -    -"
    echo "19. S1.4XLARGE64    16    64    -    8    3.5    -    -"
    echo "20. S1.6XLARGE48    24    48    -    8    5.0    -    -"
    echo "21. S1.8XLARGE64    32    64    -    8    7.0    -    -"
    echo "22. S1.12XLARGE96    48    96    -    8    10.0    -    -"
}

func_M5() {
    echo "规格    vCPU    内存 （GB）    网络收发包 (pps)    队列数    内网带宽能力 （Gbps）    主频    备注"
    echo "1. M5.SMALL8    1    8    25万    1    1.5    2.5GHz    -"
    echo "2. M5.MEDIUM16    2    16    30万    2    1.5    2.5GHz    -"
    echo "3. M5.LARGE32    4    32    50万    2    2.0    2.5GHz    -"
    echo "4. M5.2XLARGE64    8    64    80万    2    3.0    2.5GHz    -"
    echo "5. M5.3XLARGE96    12    96    100万    3    5.0    2.5GHz    -"
    echo "6. M5.4XLARGE128    16    128    150万    4    6.0    2.5GHz    -"
    echo "7. M5.8XLARGE256    32    256    250万    8    12.0    2.5GHz    -"
}

func_M4() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. M4.SMALL8    1    8    25万    1    1.5    2.4 GHz    -"
    echo "2. M4.MEDIUM16    2    16    30万    2    1.5    2.4 GHz    -"
    echo "3. M4.LARGE32    4    32    50万    2    1.5    2.4 GHz    -"
    echo "4. M4.2XLARGE64    8    64    80万    2    3.0    2.4 GHz    -"
    echo "5. M4.3XLARGE96    12    96    100万    3    4.0    2.4 GHz    -"
    echo "6. M4.3XLARGE144    12    144    100万    3    4.0    2.4 GHz    -"
    echo "7. M4.4XLARGE128    16    128    150万    4    6.0    2.4 GHz    -"
    echo "8. M4.4XLARGE192    16    192    150万    4    6.0    2.4 GHz    -"
    echo "9. M4.8XLARGE256    32    256    250万    8    11.0    2.4 GHz    -"
    echo "10. M4.8XLARGE384    32    384    250万    8    11.0    2.4 GHz    -"
    echo "11. M4.16XLARGE512    64    512    500万    16    22.0    2.4 GHz    -"
    echo "12. M4.18XLARGE648    72    648    600万    16    24.0    2.4 GHz    -"
}

func_M3() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. M3.SMALL8    1    8    30万    1    1.5    2.5 GHz    -"
    echo "2. M3.MEDIUM16    2    16    40万    2    1.5    2.5 GHz    -"
    echo "3. M3.LARGE32    4    32    80万    4    1.5    2.5 GHz    -"
    echo "4. M3.2XLARGE64    8    64    120万    8    1.5    2.5 GHz    -"
    echo "5. M3.3XLARGE96    12    96    120万    12    1.5    2.5 GHz    -"
    echo "6. M3.3XLARGE144    12    144    120万    12    1.5    2.5 GHz    -"
    echo "7. M3.4XLARGE128    16    128    120万    16    2.0    2.5 GHz    -"
    echo "8. M3.4XLARGE192    16    192    120万    16    2.0    2.5 GHz    -"
    echo "9. M3.8XLARGE256    32    256    120万    16    4.0    2.5 GHz    -"
    echo "10. M3.8XLARGE384    32    384    120万    16    4.0    2.5 GHz    -"
    echo "11. M3.16XLARGE512    64    512    120万    16    8.0    2.5 GHz    -"
}

func_M2() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. M2.SMALL8    1    8    20万    1    1.5    2.4 GHz    -"
    echo "2. M2.MEDIUM16    2    16    25万    2    1.5    2.4 GHz    -"
    echo "3. M2.LARGE32    4    32    45万    4    1.5    2.4 GHz    -"
    echo "4. M2.2XLARGE64    8    64    50万    8    1.5    2.4 GHz    -"
    echo "5. M2.3XLARGE96    12    96    50万    8    2.5    2.4 GHz    -"
    echo "6. M2.4XLARGE128    16    128    50万    8    3.0    2.4 GHz    -"
    echo "7. M2.6XLARGE192    24    192    70万    8    4.5    2.4 GHz    -"
    echo "8. M2.8XLARGE256    32    256    70万    8    6.0    2.4 GHz    -"
    echo "9. M2.12XLARGE384    48    384    70万    8    9.0    2.4 GHz    -"
    echo "10. M2.14XLARGE448    56    448    70万    8    10.0    2.4 GHz    -"
}

func_M1() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. M1.SMALL8    1    8    -    1    1.5    2.3 GHz    -"
    echo "2. M1.MEDIUM16    2    16    -    2    1.5    2.3 GHz    -"
    echo "3. M1.LARGE32    4    32    -    4    1.5    2.3 GHz    -"
    echo "4. M1.2XLARGE64    8    64    -    8    2.0    2.3 GHz    -"
    echo "5. M1.3XLARGE96    12    96    -    8    2.5    2.3 GHz    -"
    echo "6. M1.4XLARGE128    16    128    -    8    3.5    2.3 GHz    -"
    echo "7. M1.6XLARGE192    24    192    -    8    5.0    2.3 GHz    -"
    echo "8. M1.8XLARGE256    32    256    -    8    7.0    2.3 GHz    -"
    echo "9. M1.12XLARGE368    48    368    -    8    10.0    2.3 GHz    -"
}
func_IT3() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. IT3.4XLARGE64    16    64    150万    4    6    2.5 GHz    1 × 3720 GB 本地 NVMe SSD 硬盘"
    echo "2. IT3.8XLARGE128    32    128    250万    8    12    2.5 GHz    2 × 3720 GB 本地 NVMe SSD 硬盘"
    echo "3. IT3.16XLARGE256    64    256    500万    16    23    2.5 GHz    4 × 3720 GB 本地 NVMe SSD 硬盘"
}
func_D2() {
    echo "规格    vCPU    内存 （GB）    网络收发包 (pps)    队列数    内网带宽能力 （Gbps）    主频    备注"
    echo "1. D2.2XLARGE32    8    32    80万    2    3.0    2.4 GHz    搭载 1 块 11176 GB SATA HDD 本地硬盘"
    echo "2. D2.4XLARGE64    16    64    150万    4    6.0    2.4 GHz    搭载 2 块 11176 GB SATA HDD 本地硬盘"
    echo "3. D2.6XLARGE96    24    96    200万    6    8.0    2.4 GHz    搭载 3 块 11176 GB SATA HDD 本地硬盘"
    echo "4. D2.8XLARGE128    32    128    250万    8    11.0    2.4 GHz    搭载 4 块 11176 GB SATA HDD 本地硬盘"
    echo "5. D2.16XLARGE256    64    256    500万    16    22.0    2.4 GHz    搭载 8 块 11176 GB SATA HDD 本地硬盘"
    echo "6. D2.19XLARGE320    76    320    600万    16    25.0    2.4 GHz    搭载 12 块 11176 GB SATA HDD 本地硬盘"
}
func_CN3() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. CN3.LARGE8    4    8    60万    4    3.0    3.2 GHz    -"
    echo "2. CN3.LARGE16    4    16    60万    4    3.0    3.2 GHz    -"
    echo "3. CN3.2XLARGE16    8    16    100万    8    5.0    3.2 GHz    -"
    echo "4. CN3.2XLARGE32    8    32    100万    8    5.0    3.2 GHz    -"
    echo "5. CN3.4XLARGE32    16    32    100万    16    9.0    3.2 GHz    -"
    echo "6. CN3.4XLARGE64    16    64    100万    16    9.0    3.2 GHz    -"
    echo "7. CN3.8XLARGE64    32    64    100万    16    17.0    3.2 GHz    -"
    echo "8. CN3.8XLARGE128    32    128    100万    16    17.0    3.2 GHz    -"
}

func_C3() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. C3.LARGE8    4    8    60万    2    2.5    3.2 GHz    -"
    echo "2. C3.LARGE16    4    16    60万    2    2.5    3.2 GHz    -"
    echo "3. C3.2XLARGE16    8    16    100万    2    3.0    3.2 GHz    -"
    echo "4. C3.2XLARGE32    8    32    100万    2    3.0    3.2 GHz    -"
    echo "5. C3.4XLARGE32    16    32    100万    4    4.5    3.2 GHz    -"
    echo "6. C3.4XLARGE64    16    64    100万    4    4.5    3.2 GHz    -"
    echo "7. C3.8XLARGE64    32    64    100万    8    8.0    3.2 GHz    -"
    echo "8. C3.8XLARGE128    32    128    100万    8    8.0    3.2 GHz    -"
}

func_C2() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. C2.LARGE8    4    8    55万    4    2.5    3.2 GHz    -"
    echo "2. C2.LARGE16    4    16    55万    4    2.5    3.2 GHz    -"
    echo "3. C2.LARGE32    4    32    55万    4    2.5    3.2 GHz    -"
    echo "4. C2.2XLARGE16    8    16    55万    8    3.5    3.2 GHz    -"
    echo "5. C2.2XLARGE32    8    32    55万    8    3.5    3.2 GHz    -"
    echo "6. C2.4XLARGE32    16    32    85万    8    6.0    3.2 GHz    -"
    echo "7. C2.4XLARGE64    16    64    85万    8    6.0    3.2 GHz    -"
    echo "8. C2.8XLARGE96    32    96    85万    8    10.0    3.2 GHz    -"
}
func_BC1() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. BC1.LARGE16    4    16    -    4    1.5    -    -"
    echo "2. BC1.3XLARGE48    12    48    -    8    2.5    -    -"
    echo "3. BC1.6XLARGE96    24    96    -    8    5.0    -    -"

}

func_BS1() {
    echo "规格    vCPU    内存(GB)    网络收发包 (pps)    队列数    内网带宽能力(Gbps)    主频    备注"
    echo "1. BS1.LARGE8    4    8    -    4    1.5    -    -"
    echo "2. BS1.3XLARGE24    12    24    -    8    2.5    -    -"
    echo "3. BS1.6XLARGE48    24    48    -    8    5.0    -    -"
}



func_sel_reg_type() {
    read -p "Please enter the serial number of the region [ Default: ap-guangzhou ] :" REG
    if [ -z "${REG}" ];then
        REGION=ap-guangzhou
    else
        case $REG in
            "1")
                REGION=ap-beijing
                ;;
            "2")
                REGION=ap-guangzhou
                ;;
            "3")
                REGION=ap-shanghai
                ;;
            "4")
                REGION=ap-shenzhen-fsi
                ;;
            "5")
                REGION=ap-shanghai-fsi
                ;;
            "6")
                REGION=ap-chengdu
                ;;
            "7")
                REGION=ap-chongqing
                ;;
            "8")
                REGION=ap-hongkong
                ;;
            "9")
                REGION=ap-singapore
                ;;
            "10")
                REGION=ap-seoul
                ;;
            "11")
                REGION=ap-tokyo
                ;;
            "12")
                REGION=ap-mumbai
                ;;
            "13")
                REGION=ap-bangkok
                ;;   
            "14")
                REGION=na-toronto
                ;;
            "15")
                REGION=na-siliconvalley
                ;;   
            "16")
                REGION=na-ashburn
                ;;
            "17")
                REGION=eu-frankfurt
                ;;
            "18")
                REGION=eu-moscow
                ;;   
            *)
            echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
            func_sel_reg_type
            ;;
        esac
    fi
}

func_sel_zone_type() {
    read -p "plz input zone number [ Default: 3区 ] :" ZoneNum
    if [ -z "${RoneNum}" ];then
        ZoneNum="3"
        ZONE="$REGION-$ZoneNum"   
    else
        ZONE="$REGION-$ZoneNum"
    fi
}

func_sel_img_type() {
    read -p "Please enter the serial number of the ImgId [ Default: Centos7.4 ]: " IMG
    if [ -z "${IMG}" ];then
        IMGID=img-8toqc6s3
    else
        case $IMG in
            "1")
                IMGID=img-9qabwvbn
                ;;
            "2")
                IMGID=img-oikl1tzv
                ;;
            "3")
                IMGID=img-8toqc6s3
                ;;
            "4")
                IMGID=img-dkwyg6sr
                ;;
            "5")
                IMGID=img-31tjrtph
                ;;
            "6")
                IMGID=img-i5u2lkoz
                ;;
            "7")
                IMGID=img-rtp44ucv
                ;;
            "8")
                IMGID=img-6ns5om13
                ;;
            "9")
                IMGID=img-0hvei5hp
                ;;
            "10")
                IMGID=img-6rrx0ymd
                ;;
            "11")
                IMGID=img-hi93l4ht
                ;;
            "12")
                IMGID=img-ez7jwngr
                ;;
            "13")
                IMGID=img-c1y1axb9
                ;;   
            "14")
                IMGID=img-0ytr67o7
                ;;
            "15")
                IMGID=img-pi0ii46r
                ;;   
            "16")
                IMGID=img-pyqx34y1
                ;;
            "17")
                IMGID=img-8u6dn6p1
                ;;
            "18")
                IMGID=img-3wnd9xpl
                ;;
            "19")
                IMGID=img-qpxvpujt
                ;;
            "20")
                IMGID=img-9id7emv7
                ;;
            "21")
                IMGID=img-1eckhm4t
                ;;
            "22")
                IMGID=img-2tddq003
                ;;
            "23")
                IMGID=img-29hl923v
                ;;
            "24")
                IMGID=img-0vbqvzfn
                ;;
            "25")
                IMGID=img-b1ve77s9
                ;;
            "26")
                IMGID=img-mv100ns3
                ;;
            "27")
                IMGID=img-7fwdvfur
                ;;
            "28")
                IMGID=img-hdt9xxkt
                ;;
            "29")
                IMGID=img-feqctcrx
                ;;
            *)
            echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
            func_sel_img_type
            ;;
        esac
    fi
}

func_sel_cbs_type() {
    read -p "Please enter the serial number of the cbs_type [ Default: CLOUD_PREMIUM ]:" DISKT
    if [ -z "${DISKT}" ];then
        DISKTYPE="CLOUD_PREMIUM"
    else
        case $DISKT in
            "1")
                DISKTYPE=LOCAL_BASIC
                ;;
            "2")
                DISKTYPE=LOCAL_SSD
                ;;
            "3")
                DISKTYPE=CLOUD_BASIC
                ;;
            "4")
                DISKTYPE=CLOUD_PREMIUM
                ;;
            "5")
                DISKTYPE=CLOUD_SSD
                ;;   
            *)
            echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
            func_sel_cbs_type
            ;;
        esac
    fi
}

func_sel_ins_type_s5() {
    read -p "Please enter the serial number of the instances_types: " INS
                # fi
    if [ "${INS}" = "1" ]; then
        INSTANCETYPE=S5.SMALL1
    elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=S5.SMALL2
    elif [ "${INS}" = "3" ]; then
        INSTANCETYPE=S5.SMALL4
    elif [ "${INS}" = "4" ]; then
        INSTANCETYPE=S5.MEDIUM4
    elif [ "${INS}" = "5" ]; then
        INSTANCETYPE=S5.MEDIUM8
    elif [ "${INS}" = "6" ]; then
        INSTANCETYPE=S5.LARGE8
    elif [ "${INS}" = "7" ]; then
        INSTANCETYPE=S5.LARGE16
    elif [ "${INS}" = "8" ]; then
        INSTANCETYPE=S5.2XLARGE16
    elif [ "${INS}" = "9" ]; then
        INSTANCETYPE=S5.2XLARGE32
    elif [ "${INS}" = "10" ]; then
        INSTANCETYPE=S5.4XLARGE32
    elif [ "${INS}" = "11" ]; then
        INSTANCETYPE=S5.4XLARGE64
    elif [ "${INS}" = "12" ]; then
        INSTANCETYPE=S5.6XLARGE48
    elif [ "${INS}" = "13" ]; then
        INSTANCETYPE=S5.6XLARGE96
    elif [ "${INS}" = "14" ]; then
        INSTANCETYPE=S5.8XLARGE64
    elif [ "${INS}" = "15" ]; then
        INSTANCETYPE=S5.8XLARGE128
    elif [ "${INS}" = "16" ]; then
        INSTANCETYPE=S5.12XLARGE96
    elif [ "${INS}" = "17" ]; then
        INSTANCETYPE=S5.12XLARGE192
    elif [ "${INS}" = "18" ]; then
        INSTANCETYPE=S5.16XLARGE256
    else
        echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
        func_sel_ins_type_s5
    fi
}


func_sel_ins_type_s3() {
    read -p "Please enter the serial number of the instance_types [ Default: S3.SMALL2 ]: " INS
        if [ -z "${INS}" ];then
            INSTANCETYPE=S3.SMALL2
        else
                   
            if [ "${INS}" = "1" ]; then
                INSTANCETYPE=S3.SMALL1
            elif [ "${INS}" = "2" ]; then
                INSTANCETYPE=S3.SMALL2
            elif [ "${INS}" = "3" ]; then
                INSTANCETYPE=S3.SMALL4
            elif [ "${INS}" = "4" ]; then
                INSTANCETYPE=S3.MEDIUM4
            elif [ "${INS}" = "5" ]; then
                INSTANCETYPE=S3.MEDIUM8
            elif [ "${INS}" = "6" ]; then
                INSTANCETYPE=S3.LARGE8
            elif [ "${INS}" = "7" ]; then
                INSTANCETYPE=S3.LARGE16
            elif [ "${INS}" = "8" ]; then
                INSTANCETYPE=S3.2XLARGE16
            elif [ "${INS}" = "9" ]; then
                INSTANCETYPE=S3.2XLARGE32
            elif [ "${INS}" = "10" ]; then
                INSTANCETYPE=S3.3XLARGE48
            elif [ "${INS}" = "11" ]; then
                INSTANCETYPE=S3.4XLARGE32
            elif [ "${INS}" = "12" ]; then
                INSTANCETYPE=S3.4XLARGE64
            elif [ "${INS}" = "13" ]; then
                INSTANCETYPE=S3.6XLARGE48
            elif [ "${INS}" = "14" ]; then
                INSTANCETYPE=S3.6XLARGE96
            elif [ "${INS}" = "15" ]; then
                INSTANCETYPE=S3.8XLARGE64
            elif [ "${INS}" = "16" ]; then
                INSTANCETYPE=S3.8XLARGE128
            elif [ "${INS}" = "17" ]; then
                INSTANCETYPE=S3.12XLARGE96
            elif [ "${INS}" = "18" ]; then
                INSTANCETYPE=S3.12XLARGE192
            elif [ "${INS}" = "19" ]; then
                INSTANCETYPE=S3.16XLARGE128
            elif [ "${INS}" = "20" ]; then
                INSTANCETYPE=S3.16XLARGE256
            elif [ "${INS}" = "21" ]; then
                INSTANCETYPE=S3.20XLARGE320
            else
                echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                func_sel_ins_type_s3
            fi
        fi
}

func_sel_ins_type_s4() {
                read -p "Please enter the serial number of the instance_types: " INS
                # fi
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=S4.SMALL2
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=S4.MEDIUM4
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=S4.MEDIUM8
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=S4.LARGE8
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=S4.LARGE16
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=S4.2XLARGE16
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=S4.2XLARGE32
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=S4.4XLARGE32
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=S4.4XLARGE64
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=S4.6XLARGE48
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=S4.6XLARGE96
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=S4.8XLARGE64
                elif [ "${INS}" = "13" ]; then
                    INSTANCETYPE=S4.8XLARGE128
                elif [ "${INS}" = "14" ]; then
                    INSTANCETYPE=S4.12XLARGE96
                elif [ "${INS}" = "15" ]; then
                    INSTANCETYPE=S4.12XLARGE192
                elif [ "${INS}" = "16" ]; then
                    INSTANCETYPE=S4.16XLARGE128
                elif [ "${INS}" = "17" ]; then
                    INSTANCETYPE=S4.16XLARGE256
                elif [ "${INS}" = "18" ]; then
                    INSTANCETYPE=S4.18XLARGE288
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_s4               
                fi
}

func_sel_ins_type_sn3ne() {
                read -p "Please enter the serial number of thet instance_types: " INS
                # fi
               
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=SN3ne.SMALL2
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=SN3ne.MEDIUM4
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=SN3ne.LARGE8
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=SN3ne.LARGE16
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=SN3ne.2XLARGE16
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=SN3ne.2XLARGE32
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=SN3ne.3XLARGE24
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=SN3ne.4XLARGE32
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=SN3ne.4XLARGE64
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=SN3ne.6XLARGE48
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=SN3ne.6XLARGE96
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=SN3ne.8XLARGE64
                elif [ "${INS}" = "13" ]; then
                    INSTANCETYPE=SN3ne.8XLARGE128
                elif [ "${INS}" = "14" ]; then
                    INSTANCETYPE=SN3ne.12XLARGE96
                elif [ "${INS}" = "15" ]; then
                    INSTANCETYPE=SN3ne.12XLARGE192
                elif [ "${INS}" = "16" ]; then
                    INSTANCETYPE=SN3ne.16XLARGE128
                elif [ "${INS}" = "17" ]; then
                    INSTANCETYPE=SN3ne.16XLARGE256
                elif [ "${INS}" = "18" ]; then
                    INSTANCETYPE=SN3ne.18XLARGE288
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_sn3ne
                fi
}

func_sel_ins_type_s3() {
                read -p "Please enter the serial number of the instance_types [ Default: S3.SMALL2 ]: " INS
                if [ -z "${INS}" ];then
                    INSTANCETYPE=S3.SMALL2
                else
               
                    if [ "${INS}" = "1" ]; then
                        INSTANCETYPE=S3.SMALL1
                    elif [ "${INS}" = "2" ]; then
                        INSTANCETYPE=S3.SMALL2
                    elif [ "${INS}" = "3" ]; then
                        INSTANCETYPE=S3.SMALL4
                    elif [ "${INS}" = "4" ]; then
                        INSTANCETYPE=S3.MEDIUM4
                    elif [ "${INS}" = "5" ]; then
                        INSTANCETYPE=S3.MEDIUM8
                    elif [ "${INS}" = "6" ]; then
                        INSTANCETYPE=S3.LARGE8
                    elif [ "${INS}" = "7" ]; then
                        INSTANCETYPE=S3.LARGE16
                    elif [ "${INS}" = "8" ]; then
                        INSTANCETYPE=S3.2XLARGE16
                    elif [ "${INS}" = "9" ]; then
                        INSTANCETYPE=S3.2XLARGE32
                    elif [ "${INS}" = "10" ]; then
                        INSTANCETYPE=S3.3XLARGE48
                    elif [ "${INS}" = "11" ]; then
                        INSTANCETYPE=S3.4XLARGE32
                    elif [ "${INS}" = "12" ]; then
                        INSTANCETYPE=S3.4XLARGE64
                    elif [ "${INS}" = "13" ]; then
                        INSTANCETYPE=S3.6XLARGE48
                    elif [ "${INS}" = "14" ]; then
                        INSTANCETYPE=S3.6XLARGE96
                    elif [ "${INS}" = "15" ]; then
                        INSTANCETYPE=S3.8XLARGE64
                    elif [ "${INS}" = "16" ]; then
                        INSTANCETYPE=S3.8XLARGE128
                    elif [ "${INS}" = "17" ]; then
                        INSTANCETYPE=S3.12XLARGE96
                    elif [ "${INS}" = "18" ]; then
                        INSTANCETYPE=S3.12XLARGE192
                    elif [ "${INS}" = "19" ]; then
                        INSTANCETYPE=S3.16XLARGE128
                    elif [ "${INS}" = "20" ]; then
                        INSTANCETYPE=S3.16XLARGE256
                    elif [ "${INS}" = "21" ]; then
                        INSTANCETYPE=S3.20XLARGE320
                    else
                        echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                        func_sel_ins_type_s3
                    fi
                fi
}

func_sel_ins_type_s2() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=S2.SMALL1
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=S2.SMALL2
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=S2.SMALL4
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=S2.MEDIUM2
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=S2.MEDIUM4
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=S2.MEDIUM8
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=S2.LARGE8
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=S2.LARGE16
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=S2.2XLARGE16
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=S2.2XLARGE32
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=S2.3XLARGE24
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=S2.3XLARGE48
                elif [ "${INS}" = "13" ]; then
                    INSTANCETYPE=S2.4XLARGE32
                elif [ "${INS}" = "14" ]; then
                    INSTANCETYPE=S2.4XLARGE48
                elif [ "${INS}" = "15" ]; then
                    INSTANCETYPE=S2.4XLARGE64
                elif [ "${INS}" = "16" ]; then
                    INSTANCETYPE=S2.6XLARGE48
                elif [ "${INS}" = "17" ]; then
                    INSTANCETYPE=S2.6XLARGE96
                elif [ "${INS}" = "18" ]; then
                    INSTANCETYPE=S2.8XLARGE64
                elif [ "${INS}" = "19" ]; then
                    INSTANCETYPE=S2.8XLARGE128
                elif [ "${INS}" = "20" ]; then
                    INSTANCETYPE=S2.14XLARGE224
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_s2
                   
                fi
}

func_sel_ins_type_sa1() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=SA1.SMALL1
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=SA1.SMALL2
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=SA1.SMALL4
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=SA1.MEDIUM4
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=SA1.MEDIUM8
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=SA1.LARGE8
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=SA1.LARGE16
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=SA1.2XLARGE16
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=SA1.2XLARGE32
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=SA1.4XLARGE32
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=SA1.4XLARGE64
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_sa1
                fi
}

func_sel_ins_type_s2ne() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=S2ne.SMALL2
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=S2ne.MEDIUM4
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=S2ne.LARGE8
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=S2ne.LARGE16
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=S2ne.2XLARGE16
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=S2ne.2XLARGE32
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=S2ne.3XLARGE24
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=S2ne.3XLARGE48
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=S2ne.4XLARGE32
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=S2ne.4XLARGE64
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=S2ne.6XLARGE48
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=S2ne.6XLARGE96
                elif [ "${INS}" = "13" ]; then
                    INSTANCETYPE=S2ne.8XLARGE64
                elif [ "${INS}" = "14" ]; then
                    INSTANCETYPE=S2ne.8XLARGE128
                elif [ "${INS}" = "15" ]; then
                    INSTANCETYPE=S2ne.12XLARGE192
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_s2ne
                fi
}

func_sel_ins_type_s1() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=S1.SMALL1
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=S1.SMALL2
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=S1.SMALL4
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=S1.MEDIUM2
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=S1.MEDIUM4
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=S1.MEDIUM8
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=S1.MEDIUM12
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=S1.LARGE4
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=S1.LARGE8
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=S1.LARGE16
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=S1.2XLARGE8
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=S1.2XLARGE16
                elif [ "${INS}" = "13" ]; then
                    INSTANCETYPE=S1.2XLARGE32
                elif [ "${INS}" = "14" ]; then
                    INSTANCETYPE=S1.3XLARGE24
                elif [ "${INS}" = "15" ]; then
                    INSTANCETYPE=S1.3XLARGE48
                elif [ "${INS}" = "16" ]; then
                    INSTANCETYPE=S1.4XLARGE16
                elif [ "${INS}" = "17" ]; then
                    INSTANCETYPE=S1.4XLARGE32
                elif [ "${INS}" = "18" ]; then
                    INSTANCETYPE=S1.4XLARGE48
                elif [ "${INS}" = "19" ]; then
                    INSTANCETYPE=S1.4XLARGE64
                elif [ "${INS}" = "20" ]; then
                    INSTANCETYPE=S1.6XLARGE48
                elif [ "${INS}" = "21" ]; then
                    INSTANCETYPE=S1.8XLARGE64
                elif [ "${INS}" = "22" ]; then
                    INSTANCETYPE=S1.12XLARGE96
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_s1
                   
                fi
}

func_sel_ins_type_m5() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=M5.SMALL8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=M5.MEDIUM16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=M5.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=M5.2XLARGE64
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=M5.3XLARGE96
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=M5.4XLARGE128
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=M5.8XLARGE256
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_m5
                   
                fi
}

func_sel_ins_type_m4() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=M4.SMALL8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=M4.MEDIUM16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=M4.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=M4.2XLARGE64
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=M4.3XLARGE96
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=M4.3XLARGE144
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=M4.4XLARGE128
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=M4.4XLARGE192
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=M4.8XLARGE256
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=M4.8XLARGE384
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=M4.16XLARGE512
                elif [ "${INS}" = "12" ]; then
                    INSTANCETYPE=M4.18XLARGE648
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_m4
                fi
}

func_sel_ins_type_m3() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=M3.SMALL8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=M3.MEDIUM16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=M3.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=M3.2XLARGE64
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=M3.3XLARGE96
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=M3.3XLARGE144
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=M3.4XLARGE128
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=M3.4XLARGE192
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=M3.8XLARGE256
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=M3.8XLARGE384
                elif [ "${INS}" = "11" ]; then
                    INSTANCETYPE=M3.16XLARGE512
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_m3
                fi
}

func_sel_ins_type_m2() {
                read -p "Please enter the serial number of thet instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=M2.SMALL8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=M2.MEDIUM16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=M2.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=M2.2XLARGE64
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=M2.3XLARGE96
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=M2.4XLARGE128
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=M2.6XLARGE192
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=M2.8XLARGE256
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=M2.12XLARGE384
                elif [ "${INS}" = "10" ]; then
                    INSTANCETYPE=M2.14XLARGE448
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_m2
                fi
}

func_sel_ins_type_m1() {
                read -p "Please enter the serial number of thet instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=M1.SMALL8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=M1.MEDIUM16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=M1.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=M1.2XLARGE64
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=M1.3XLARGE96
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=M1.4XLARGE128
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=M1.6XLARGE192
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=M1.8XLARGE256
                elif [ "${INS}" = "9" ]; then
                    INSTANCETYPE=M1.12XLARGE368
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_m1
                fi
}

func_sel_ins_type_it3() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=IT3.4XLARGE64
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=IT3.8XLARGE128
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=IT3.16XLARGE256
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_it3
                fi
}

func_sel_ins_type_d2() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=D2.2XLARGE32
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=D2.4XLARGE64
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=D2.6XLARGE96
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=D2.8XLARGE128
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=D2.16XLARGE256
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=D2.19XLARGE320
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_d2
                fi
}

func_sel_ins_type_cn3() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=CN3.LARGE8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=CN3.LARGE16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=CN3.2XLARGE16
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=CN3.2XLARGE32
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=CN3.4XLARGE32
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=CN3.4XLARGE64
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=CN3.8XLARGE64
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=CN3.8XLARGE128
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_cn3
                fi
}

func_sel_ins_type_c3() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=C3.LARGE8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=C3.LARGE16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=C3.2XLARGE16
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=C3.2XLARGE32
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=C3.4XLARGE32
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=C3.4XLARGE64
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=C3.8XLARGE64
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=C3.8XLARGE128
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_c3
                fi
}

func_sel_ins_type_c2() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=C2.LARGE8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=C2.LARGE16
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=C2.LARGE32
                elif [ "${INS}" = "4" ]; then
                    INSTANCETYPE=C2.2XLARGE16
                elif [ "${INS}" = "5" ]; then
                    INSTANCETYPE=C2.2XLARGE32
                elif [ "${INS}" = "6" ]; then
                    INSTANCETYPE=C2.4XLARGE32
                elif [ "${INS}" = "7" ]; then
                    INSTANCETYPE=C2.4XLARGE64
                elif [ "${INS}" = "8" ]; then
                    INSTANCETYPE=C2.8XLARGE96
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_c2
                fi
}

func_sel_ins_type_bc1() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=BC1.LARGE16
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=BC1.3XLARGE48
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=BC1.6XLARGE96
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_bc1
                fi
}

func_sel_ins_type_bs1() {
                read -p "Please enter the serial number of the instance_types: " INS
                if [ "${INS}" = "1" ]; then
                    INSTANCETYPE=BS1.LARGE8
                elif [ "${INS}" = "2" ]; then
                    INSTANCETYPE=BS1.3XLARGE24
                elif [ "${INS}" = "3" ]; then
                    INSTANCETYPE=BS1.6XLARGE48
                else
                    echo -e "\033[5;31m Your input is error! plz input again ! \033[0m"
                    func_sel_ins_type_bs1
                fi
}

func_sel_ins_type_total() {
    read -p "Please enter the serial number of the instance_type [ Default: S3 ]: " INSTANCE_TYPE
    if [ -z "${INSTANCE_TYPE}" ];then
        INSTANCE_TYPE="4"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        func_S3
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        func_sel_ins_type_s3
    else
        case $INSTANCE_TYPE in
            "1")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S5
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s5
               
                ;;
            "2")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S4
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s4
                ;;
            "3")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_SN3ne
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_sn3ne
                ;;
            "4")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S3
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s3
                ;;
            "5")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S2
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s2
                ;;
            "6")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_SA1
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_sa1
                ;;
            "7")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S2ne
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s2ne
                ;;
            "8")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_S1
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_s1
                ;;
            "9")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_M5
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_m5
                ;;
            "10")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_M4
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_m4
                ;;
            "11")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_M3
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_m3
                ;;
            "12")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_M2
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_m2
                ;;
            "13")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_M1
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_m1
                ;;   
            "14")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_IT3
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_it3
                ;;
            "15")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_D2
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_d2
                ;;   
            "16")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_CN3
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_cn3
                ;;
            "17")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_C3
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_c3
                ;;
            "18")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_C2
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_c2
                ;;
            "19")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_BC1
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_bc1
                ;;
            "20")
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_BS1
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                func_sel_ins_type_bs1
                ;;   
            *)
            echo -e "\033[5;31m Your region is error! plz input again ! \033[0m"
            func_sel_ins_type_total
            ;;
        esac
    fi
}

func_del() {
    echo "1. Delete All"
    echo "2. Select Delete"
}

func_sel_region() {
    func_sel_reg_type
}

func_sel_zone() {
    func_sel_zone_type
}

func_sel_img() {
    func_sel_img_type
}

func_sel_cbs() {
    func_sel_cbs_type
}

func_sel_ins_type() {
    func_sel_ins_type_total
}

func_sel_ins_name() {
    read -p "Please enter the InstanceName [ Default: ZHUJH-TEST ]: " INSTANCENAME
    if [ -z "${INSTANCENAME}" ];then
        INSTANCE_NAME=ZHUJH-TEST
    else
        INSTANCE_NAME=$INSTANCENAME
    fi
}

func_sel_host_name() {
    read -p "Please enter the HostName [ Default: TEST ]: " HostN
    if [ -z "${HostN}" ];then
        HOST_NAME=TEST
    else
        HOST_NAME=$HostN
    fi
}

func_sel_ins_num() {
    read -p "How many instances are needed [ Default: 1 ]: " INS_NUM
    if [ -z "${INS_NUM}" ];then
        INS_NUM_REAL=1
    elif [[ ! ${INS_NUM} =~ ^[1-9]\d*$ ]]; then
        echo -e "\033[5;31m Please enter a number, not another character ! \033[0m"
        func_sel_ins_num
    else
        INS_NUM_REAL=$INS_NUM
    fi
}
func_sel_action() {
    echo "1. 创建实例 "
    echo "2. 销毁实例 "
}

func_exec() {
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_region
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_region
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_zone
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_img
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_img
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_cbs
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_cbs
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_instancetype
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_ins_type
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_ins_name
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_host_name
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_ins_num
	
 VPCID=`tccli vpc DescribeSubnets --region $REGION --filter 'SubnetSet[*].{Zone:Zone,VpcId:VpcId,SubnetId:SubnetId}' | grep -B 1 $ZONE | awk -F "\"" '{print $4}' | head -1`
 SUBNETID=`tccli vpc DescribeSubnets --region $REGION --filter 'SubnetSet[*].{Zone:Zone,VpcId:VpcId,SubnetId:SubnetId}' | grep -B 2 $ZONE | awk -F "\"" '{print $4}' | head -1`
 echo $REGION
 SECURITYGROUPIDS=`tccli vpc DescribeSecurityGroups --region $REGION --filter 'SecurityGroupSet[*].{SecurityGroupName:SecurityGroupName,SecurityGroupId:SecurityGroupId}' | grep -B 1 "放通全部" | head -1 | awk -F "\"" '{print $4}'`
 echo "Start creating instances..."
}

func_deploy() {
 while [ 0 -eq 0 ]
 do
  echo ".................. job begin ..................."   
  func_exec
  tccli cvm RunInstances --InstanceChargeType POSTPAID_BY_HOUR --InstanceChargePrepaid '{"Period":1,"RenewFlag":"DISABLE_NOTIFY_AND_MANUAL_RENEW"}' --VirtualPrivateCloud "{\"VpcId\":\"$VPCID\",\"SubnetId\":\"$SUBNETID\",\"AsVpcGateway\":\"FALSE\"}" --InstanceType $INSTANCETYPE --ImageId $IMGID --SystemDisk "{\"DiskType\":\"$DISKTYPE\",\"DiskSize\":50}" --InternetAccessible '{"InternetChargeType":"TRAFFIC_POSTPAID_BY_HOUR","InternetMaxBandwidthOut":2,"PublicIpAssigned":true}' --InstanceCount $INS_NUM_REAL --InstanceName $INSTANCE_NAME --LoginSettings '{"Password":"1qaz1QAZ!!!!"}' --SecurityGroupIds "[\"$SECURITYGROUPIDS\"]" --HostName $HOST_NAME --Placement "{\"Zone\":\"$ZONE\"}" --region $REGION > /tmp/tccli.txt 
  cat /tmp/tccli.txt | grep "TencentCloudSDKException"
  if [ $? -ne 0 ]; then
   for i in `cat /tmp/tccli.txt`
   do
    echo $i
   done
   echo "--------------- job complete,plz waiting... ---------------"
   echo " "
     sleep 8
     tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME | grep null
     if [ $? -ne 0 ]; then
      echo " Your instance has been created successfully...,the instance information is as follows:"
      tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME
     else
      echo " Warning: IP is [ null ], please query again through the following command :"
      echo -e "\033[31m tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME \033[0m"
     fi
   break;
  else
   echo "...............error occur, retry in 2 seconds .........."
   echo ""
   sleep 2
  fi
 done
}

func_exec1() {
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_region
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_region
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
 func_sel_ins_name
	
 tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -C 5 $INSTANCE_NAME

}
fun_sel_del() {
 read -p "Select the instance you want to delete: " INSTANCE_TMP
 if [ -z "${INSTANCE_TMP}" ];then
  echo -e "\033[5;31m Please enter an instanceID.Please re-enter \033[0m"
  fun_sel_del
 elif [[ ! ${INSTANCE_TMP} =~ ^'ins-'* ]]; then
  echo -e "\033[5;31m Please enter the correct instance id, such as [ins-xxxxxxxx] \033[0m"
  fun_sel_del
 else
  read -p " Are you sure you want to delete it [ Y/n ] " SUR
  if [ -z "${SUR}" ] || [ "${SUR}" = "Y" ] || [ "${SUR}" = "y" ] || [ "${SUR}" = "yes" ] || [ "${SUR}" = "YES" ]; then  
   tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$INSTANCE_TMP\"]"
   echo -e "\033[31m Instance [ ${INSTANCE_TMP} ] deletion complete... \033[0m"
   echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
   func_exec1
   func_del_real
  else
   echo -e "\033[31m Please retype or press the keyboard CTRL+C to exit ! \033[0m"
   func_del_real
  fi
   
 fi
}
func_del_real() {
 echo -e "\033[31m Start Terminating instances... \033[0m"
 func_del
 read -p "Would you like to delete all or their choice to delete The instance name is an instance of [ ${INSTANCE_NAME} ]... Please select the delete option serial number [ Default: Delete all ]: " DelOpt
	
 if [ -z "${DelOpt}" ];then
  echo -e "\033[31m Delete All... \033[0m"
  for ins_tmp in `tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME | grep instanceid | awk -F "\"" '{print $4}'`
  do
   tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$ins_tmp\"]"
   echo -e "\033[31m Instance [ ${ins_tmp} ] deletion complete... \033[0m"
  done
  
  tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME
  if [ $? -ne 0 ]; then
   echo -e "\033[5;31m No instances need to be deleted ! \033[0m"
  fi
  
  echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
  func_exec1
  func_del_real
 else 
  case $DelOpt in
   "1")
    echo -e "\033[31m Delete All... \033[0m"
    for ins_tmp in `tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME | grep instanceid | awk -F "\"" '{print $4}'`
    do
     tccli cvm TerminateInstances --region $REGION --InstanceIds "[\"$ins_tmp\"]"
     echo -e "\033[31m Instance [ ${ins_tmp} ] deletion complete... \033[0m"
    done
    tccli cvm DescribeInstances --region $REGION --filter '*[*].{instancename:InstanceName,instanceid:InstanceId,createtime:CreatedTime,IP:PublicIpAddresses,PrivateIP:PrivateIpAddresses}' | grep -B 4 $INSTANCE_NAME
    if [ $? -ne 0 ]; then
     echo -e "\033[5;31m No instances need to be deleted ! \033[0m"
    fi
    echo -e "\033[31m Need to delete please continue or press the keyboard CTRL+C to exit ! \033[0m"
    func_exec1
    func_del_real
    ;;
   "2")
    fun_sel_del
    ;; 
   *)
   echo "\033[5;31m Your input is error! plz input agian ! \033[0m"
   func_del_real
   ;;
  esac
 fi
}
func_sel_act() {
read -p "Please enter the program number to be executed [ Default: Create CVM ]: " ACTION_NUM
if [ -z "${ACTION_NUM}" ];then
 func_deploy
else 
 case $ACTION_NUM in
  "1")
   func_deploy
   ;;
  "2")
   func_exec1
   func_del_real
   ;; 
  *)
  echo -e "\033[5;31m Your input is error! plz input agian ! \033[0m"
  func_sel_act
  ;;
 esac
fi
}

main() {
 func_sel_action
 func_sel_act
}
main
