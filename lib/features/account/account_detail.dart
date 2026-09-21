enum AccountDetail {
  fullName('full_name', 'Full Name'),
  contactNumber('contact_number', 'Contact Number'),
  dateOfBirth('date_of_birth', 'Date of Birth'),
  gender('gender', 'Gender');

  const AccountDetail(this.apiKey, this.label);

  final String apiKey;
  final String label;
}
