# cloud9

## 事前準備

### .direnv の作成

```sh
direnv edit .

export AWS_ACCOUNT_ID=(Account ID)
export AWS_ACCESS_KEY_ID=(Access key ID)
export AWS_SECRET_ACCESS_KEY=(Secret access key)
export AWS_DEFAULT_REGION=ap-northeast-1
```

### terraform の初期化

```sh
rm -rf .terraform
terraform init -backend-config=backend.hcl
```

## 実行

```sh
# リソース作成
terraform apply

# リソース削除
terraform destroy
```

## 参考

- [Terraform Registry Resource: aws_cloud9_environment_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2)
- [Terraform Registry Resource: aws_cloud9_environment_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_membership)

- [github dogharasu/terraform-cloud9-ssh-env](https://github.com/dogharasu/terraform-cloud9-ssh-env)

- [AWS Cloud9 のドキュメント](https://docs.aws.amazon.com/ja_jp/cloud9/index.html)
  - [ユーザーガイド](https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/index.html)
    - [AWS Cloud9 のチュートリアルとサンプル](https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/tutorials.html)
