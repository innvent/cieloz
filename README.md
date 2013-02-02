[<img src="https://secure.travis-ci.org/fabiolnm/cieloz.png"/>](http://travis-ci.org/fabiolnm/cieloz)

# Cieloz

A utility gem for SpreeCielo Gateway gem.

## Getting Started

This is a step-by-step guide to enable Cielo Gateway as a payment method to your e-commerce store.

First, you should create your credentials at the following Cielo Page:

![Credentials](https://raw.github.com/fabiolnm/cieloz/master/readme/credentials.png)

Then a form will be presented to be filled with Store, Store's Owner, Store's Address* and Banking data.
* address must be the same as the present at Store CNPJ!

After the form is submitted, a receipt number is generated, and generally in one or two business days,
Cielo sends an e-mail with detailed instructions and manuals:

 * [Email example](https://raw.github.com/fabiolnm/cieloz/master/readme/email_cielo.pdf)
 * [Security Guide](https://raw.github.com/fabiolnm/cieloz/master/readme/cielo_guia_seguranca_ecommerce.pdf)
 * [Affiliation Contract](https://raw.github.com/fabiolnm/cieloz/master/readme/contrato_de_afiliacao_ao_sistema_cielo.pdf)
 * [Preventive Tips for securing sales](https://raw.github.com/fabiolnm/cieloz/master/readme/dicas_preventivas_para_vendas_mais_seguras.pdf)
 * [Required documents for affiliation](https://raw.github.com/fabiolnm/cieloz/master/readme/lista_de_documentos_necessarios_para_afiliacao_de_vendas_pela_internet_pessoa_juridica.pdf)
 * [Risk Terms](https://raw.github.com/fabiolnm/cieloz/master/readme/termo_de_adesao_de_risco.pdf)

##### NOTE
These were the documents sent by Cielo at December 21, 2012, and are subject to changes according to the Cielo affiliation processs changes.
If you notice any document is changed since then, and wants to collaborate on keeping this gem updated, please open an issue
so our team can update this README.

##### Cielo Developer Kit
Additionaly, the email provides a link where the Cielo Integration Kit can be downloaded:

  http://www.cielo.com.br/portal/kit-e-commerce-cielo.html

This kit contais the API documentation that served as a basis to developing this gem:
[Cielo e-commerce Developer Guide v2.0.3](https://raw.github.com/fabiolnm/cieloz/master/readme/cielo_developer_guide_2.0.3.pdf).

### The Test Environment

The page 32 of this manual provides information about a Test Environment that can be used as a sandbox
to test integration with Cielo Web Services:

  https://qasecommerce.cielo.com.br/servicos/ecommwsec.do

It also provides API ID and API Secret that are required to be sent within every request sent
to Cielo Web Services, and valid test credit card numbers to be used at this environment.

### The Cielo Payment Workflow

#### Hosted Buy Page versus Store Buy Page

Credit Card data can be provided directly to a Store BuyPage, but this requires the Store
Owner to handle with security issues.

The simplest alternative to get started is using an environment provided by the Cielo
infrastructure. When the user is required to type his credit card data, he is redirected
to a Cielo Hosted Buy Page. When the user submits his data, he's redirected back to
a Callback URL provided by the store.


#### Supported CreditCard operations

The following diagram was extracted from Cielo Developer Guide v2.0.3, page 5.

![Payment States](https://raw.github.com/fabiolnm/cieloz/master/readme/supported_products.png)

#### TransactionRequest (RequisicaoTransacao)

Every payment starts with a TransactionRequest. In the Hosted Mode, its main data are:
 * Order Data (DadosPedido)
 * PaymentMethod (FormaPagamento)
 * Authorization Mode (whether it supports Authentication Programs)
 * Capture Mode (can be util for fraud prevention)

In Store Mode, it also should include Credit Card Data (DadosPortador).

##### Authorization Modes

Visa and Mastercard supports Authentication Programs. This means additional security, as the
user is required to provide additional security credentials with his bank to be able to
have a transaction authorized for online payments:

 * [Verified by Visa](https://raw.github.com/fabiolnm/cieloz/master/readme/verified_by_visa.png),
   from this [source](http://www.verifiedbyvisa.com.br/aspx/funciona/comofunciona.aspx)
 * [MasterCard Secure Code](https://raw.github.com/fabiolnm/cieloz/master/readme/mastercard_securecodedemo.swf),
   from this [source](https://www.mycardsecure.com/vpas/certegy_mc/i18n/en_US/securecodedemo.swf)

Additionaly, a specific authorization mode is available to enable recurrent payments, in the
case they are supported by the Credit Card operator.

#### Transaction States and Web Service Operations

The following diagram was extracted from Cielo Developer Guide v2.0.3, page 9.

![Payment States](https://raw.github.com/fabiolnm/cieloz/master/readme/cielo_payment_states.png)

When a TransactionRequest succeeds, it responds with a Transaction (Transacao) with Status 0 - CREATED.
This response contains the Transaction ID (TID), and an Authentication URL (url-autenticacao)
where the user must be redirected to start the Authorization flow.

When the user visits this URL, the transaction assumes Status 1 - IN_PROGRESS.
When the user submits its Credit Card data, the transaction can assume Authentication States,
if supported by the selected credit card (Verified by Visa or MasterCard Secure Code programs).

After authentication/authorization flow, if the user has available credit, the
transaction assumes Status 4 - AUTHORIZED (Autorizada).

When the transaction is at AUTHORIZED state, the Store Owner must capture this payment in the
next five days. This can be done with a CaptureRequest (RequisicaoCaptura)

The Store Owner also has the option to request automatic payment capture, bypassing AUTHORIZED state.
After capture, the transaction assumes Status 6 - CAPTURED (Capturada).

* Manual Capture can be useful for fraud prevention, but it requires aditional Admin efforts.

In the 90 days that follows the Authorization or Capture, the transaction can be fully or
partially cancelled, assuming state 9 - CANCELLED (Cancelada). This can be done with a
CancelRequest (RequisicaoCancelamento).

* At any time, a pending request can be expired at Cielo Gateway, that puts the transaction in CANCELLED state.
* Each state has its own expire time, see the Developer Guide for detailed information.

At any time, a QueryRequest (RequisicaoConsulta) can be made for a specific transaction
(identified by its TID) to query about the state of the transaction.

### What is this gem about?

This gem provides a Ruby integration solution that consumes Cielo Web Services.

A developer just instantiates one of the available operations:

 * RequisicaoTransacao
 * RequisicaoConsulta
 * RequisicaoCaptura
 * RequisicaoCancelamento

Then populates them with appropriate data. This gem validates these request objects according to
Cielo Specifications present at Developer Manual), so it makes error handling easier, before the
request is sent to Cielo Web Service.

If the operation is valid, this gem serializes them as XML and submits to Cielo, parsing the
response as a Transaction (Transacao) or Error (Erro) objects. Both keeps the original XML response
as a xml attribute, so it can be logged.

## Installation

Add this line to your application's Gemfile:

    gem 'cieloz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cieloz

## Usage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
