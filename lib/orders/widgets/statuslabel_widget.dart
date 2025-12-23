  String getStatusLabel(String status) {
    switch (status) {
      case 'PENDING_PAYMENT':
        return 'Pending Payment';
      case 'PAID':
        return 'Paid';
      case 'PENDING_ADMIN_VERIFICATION':
        return 'Admin Review';
        case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }