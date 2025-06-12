1. Install AWS CLI and Terraform
```bash
brew install aws tenv
```

<img src="assets/1.png">

2. Create IAM User and Configure MFA
3. Configure AWS CLI
```bash
USER_NAME=rs-dd-user-task-1
aws iam create-user --user-name "$USER_NAME"
POLICIES=(
  "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  "arn:aws:iam::aws:policy/IAMFullAccess"
  "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
)

for p in "${POLICIES[@]}"; do
  aws iam attach-user-policy --user-name "$USER_NAME" --policy-arn "$p"
done

aws iam create-virtual-mfa-device \
     --virtual-mfa-device-name "${USER_NAME}-mfa" \
     --outfile "./qr-${USER_NAME}.png" \
     --bootstrap-method QRCodePNG
     
aws iam enable-mfa-device \
     --user-name "$USER_NAME" \
     --serial-number "arn:aws:iam::<*******>:mfa/${USER_NAME}-mfa" \
     --authentication-code1 "******" \
     --authentication-code2 "******"
     
aws iam list-mfa-devices --user-name "$USER_NAME"

aws iam create-access-key --user-name "$USER_NAME"

aws ec2 describe-instance-types --instance-types t4g.nano --profile rs-dd-user-task-1
```

<img src="assets/2.jpg">
