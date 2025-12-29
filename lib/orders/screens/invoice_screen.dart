import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:animal_kart_demo2/orders/models/order_model.dart';
import 'package:animal_kart_demo2/orders/widgets/custom_widgets.dart';

class InvoiceGenerator {
  static Future<String> generateInvoice(OrderUnit order) async {
    final pdf = pw.Document();

    /// ---------- BUSINESS LOGIC ----------
    double baseUnitCost = order.baseUnitCost;       // from backend
    double cpfUnitCost = order.cpfUnitCost;         // from backend
    double units = order.numUnits;

    // Subtotal = units × baseUnitCost
    double subtotalAmount =  baseUnitCost;

    // CPF calculation
    double cpfAmount = order.withCpf ? cpfUnitCost : 0.0;
    double totalAmount = subtotalAmount + cpfAmount;

    /// ---------- ASSETS ----------
    final logoImage = pw.MemoryImage(
      (await rootBundle.load("assets/images/murrah_5.jpeg")).buffer.asUint8List(),
    );

    final bgSvg = pw.SvgImage(
      svg: await rootBundle.loadString('assets/images/invoice_background.svg'),
    );

    /// ---------- PDF PAGE ----------
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(opacity: 0.08, child: bgSvg),
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  /// HEADER
                  pw.Column(
                    children: [
                      pw.Image(logoImage, height: 70),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Markwave India Private Limited",
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "CIN: U62013TS2025PTC201549",
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Divider(height: 30),

                  /// TITLE
                  pw.Center(
                    child: pw.Text(
                      "INVOICE",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#673AB7"),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  /// INFO
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _infoColumn("Invoice No", order.id),
                      _infoColumn("Order Date", formatOrderDate(order.approvalDate)),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  /// ADDRESS
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _addressBlock("Invoice Address", "Kurnool, Andhra Pradesh"),
                      _addressBlock("Shipping Address", "PSR Prime Towers, DLF, Hyderabad, Telangana, 500081"),
                    ],
                  ),
                  pw.SizedBox(height: 30),

                  /// TABLE
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey),
                    columnWidths: {
                      0: pw.FlexColumnWidth(3),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                      3: pw.FlexColumnWidth(1),
                    },
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColor.fromHex('#EEEEEE')),
                        children: [
                          _tableHeader("Description"),
                          _tableHeader("Qty"),
                          _tableHeader("Unit Price"),
                          _tableHeader("Amount"),
                        ],
                      ),

                      /// BASE COST ROW
                      buildRow(
                        "Breed: ${order.breedId}\nBuffalos: ${order.buffaloCount}\nCalves: ${order.calfCount}",
                        "$units",                          // Qty
                        FormatUtils.formatAmount(baseUnitCost), // Unit Price (base unit cost)
                        FormatUtils.formatAmount(baseUnitCost), // Amount (per unit, not multiplied)
                      ),

                      /// CPF ROW
                      if (order.withCpf && cpfUnitCost > 0)
                        buildRow(
                          "CPF Amount",
                          "$units",                          // Qty (number of units)
                          FormatUtils.formatAmount(cpfUnitCost), // Unit Price (CPF per unit)
                          FormatUtils.formatAmount(cpfUnitCost), // Amount (per unit, not multiplied)
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 25),

                  /// SUMMARY
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        _priceRow("Subtotal", FormatUtils.formatAmount(subtotalAmount)),
                        if (order.withCpf && cpfUnitCost > 0)
                          _priceRow("CPF", FormatUtils.formatAmount(cpfAmount)),
                        pw.Divider(),
                        _priceRow("Total", FormatUtils.formatAmount(totalAmount), bold: true),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  _termsAndConditions(),
                  pw.Spacer(),

                  /// FOOTER
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "405, 4th Floor, PSR Prime Tower, Gachibowli, Telangana - 500032",
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Page 1 of 1",
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice_${order.id}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  /// HELPERS
  static pw.Widget _tableHeader(String text) => pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
      );

  static pw.TableRow buildRow(String desc, String qty, String price, String total) =>
      pw.TableRow(
        children: [
          _cell(desc),
          _cell(qty, center: true),
          _cell(price, center: true),
          _cell(total, center: true),
        ],
      );

  static pw.Widget _cell(String text, {bool center = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
        ),
      );

  static pw.Widget _priceRow(String label, String value, {bool bold = false}) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            "$label: ",
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      );

  static pw.Widget _termsAndConditions() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Terms & Conditions",
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "1. This purchase is non-refundable.\n"
            "2. Once the order is confirmed, no cancellation or refund will be provided.\n"
            "3. The company is not responsible for delays caused by unforeseen circumstances.\n"
            "4. This invoice is generated electronically and does not require a signature.",
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
        ],
      );

  static pw.Widget _infoColumn(String label, String value) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      );

  static pw.Widget _addressBlock(String title, String value) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      );
}

/// DATE FORMAT

String formatOrderDate(DateTime? date) {
  if (date == null) return "";
  return DateFormat('dd MMM yyyy, hh:mm a')
      .format(date.toLocal()); // convert to local time
}
