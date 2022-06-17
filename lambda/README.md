# lambda

## 事前準備

### .direnv の作成

``` sh
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

- [Terraform Registry Resource: aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
- [Terraform Registry Resource: aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)
- [Terraform Registry Resource: aws_lambda_function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url)

- [AWS Lambda Function URLsをTerraformで実装してみる](https://techblog.nhn-techorus.com/archives/19063)
- [Terraformで、AWS Lambda関数を登録して動かしてみる](https://qiita.com/charon/items/19ab5087f7036dafce4b)
- [TerraformでLambda[Python]のデプロイするときのプラクティス](https://dev.classmethod.jp/articles/terraform-lambda-deployment/)
