class Transactions {
  int id;
  String description;
  String date;
  bool paid;
  int amountCents;
  int totalInstallments;
  int installment;
  bool recurring;
  int accountId;
  String accountType;
  int categoryId;
  dynamic contactId;
  String notes;
  int attachmentsCount;
  int creditCardId;
  int creditCardInvoiceId;
  dynamic paidCreditCardId;
  dynamic paidCreditCardInvoiceId;
  dynamic opositeTransactionId;
  dynamic opositeAccountId;
  String createdAt;
  String updatedAt;

  Transactions({
    this.id,
    this.description,
    this.date,
    this.paid,
    this.amountCents,
    this.totalInstallments,
    this.installment,
    this.recurring,
    this.accountId,
    this.accountType,
    this.categoryId,
    this.contactId,
    this.notes,
    this.attachmentsCount,
    this.creditCardId,
    this.creditCardInvoiceId,
    this.paidCreditCardId,
    this.paidCreditCardInvoiceId,
    this.opositeTransactionId,
    this.opositeAccountId,
    this.createdAt,
    this.updatedAt,
  });

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    date = json['date'];
    paid = json['paid'];
    amountCents = json['amount_cents'];
    totalInstallments = json['total_installments'];
    installment = json['installment'];
    recurring = json['recurring'];
    accountId = json['account_id'];
    accountType = json['account_type'];
    categoryId = json['category_id'];
    contactId = json['contact_id'];
    notes = json['notes'];
    attachmentsCount = json['attachments_count'];
    creditCardId = json['credit_card_id'];
    creditCardInvoiceId = json['credit_card_invoice_id'];
    paidCreditCardId = json['paid_credit_card_id'];
    paidCreditCardInvoiceId = json['paid_credit_card_invoice_id'];
    opositeTransactionId = json['oposite_transaction_id'];
    opositeAccountId = json['oposite_account_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
