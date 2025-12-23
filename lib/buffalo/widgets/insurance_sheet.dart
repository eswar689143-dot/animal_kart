import 'package:animal_kart_demo2/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class InsuranceSheet extends StatelessWidget {
  final int price;
  final int insurance;
  final int quantity;
  final bool showCancelIcon;
  final bool showNote;
  final bool isDragShowIcon;

  const InsuranceSheet({
    super.key,
    required this.price,
    required this.insurance,
    required this.quantity,
    this.showCancelIcon = true,
    this.showNote = true,
    this.isDragShowIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    // Calculate rows based on quantity
    final rows = _generateRows();
    final int grandTotal = rows.fold(0, (sum, row) => sum + row.total);

    final TextStyle headerStyle = TextStyle(
      fontSize: isSmallScreen ? 12 : 14,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// DRAG HANDLE
              if (isDragShowIcon)
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr("CPF (Cattle Protection Fund) Offer"),
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (showCancelIcon)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              /// DYNAMIC INSURANCE TABLE
              _buildInsuranceTable(
                context,
                rows,
                headerStyle,
              ),

              const SizedBox(height: 12),

              /// GRAND TOTAL
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFDFF7ED),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr("grandTotal"),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "₹${grandTotal.toString()}",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              /// NOTE
              if (showNote) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFFF7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    context.tr("insurance_note"),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Generate rows based on quantity
  List<InsuranceRow> _generateRows() {
    List<InsuranceRow> rows = [];
    
    // Each quantity step represents 0.5 units (1 buffalo + 1 calf)
    // So we need to generate rows equal to quantity
    for (int i = 1; i <= quantity; i++) {
      final bool isFreeCpf = (i % 2 == 0); // Even rows get free CPF
      final int total = isFreeCpf ? price : price + insurance;
      
      rows.add(InsuranceRow(
        serialNumber: i,
        price: price,
        insurance: insurance,
        isFreeCpf: isFreeCpf,
        total: total,
      ));
    }
    
    return rows;
  }

  /// ===================== TABLE =====================
  Widget _buildInsuranceTable(
    BuildContext context,
    List<InsuranceRow> rows,
    TextStyle headerStyle,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF10B981)),
      ),
      child: Column(
        children: [
          /// HEADER
          _tableRow(
            context,
            isHeader: true,
            bgColor: const Color(0xFFDFF7ED),
            children: [
              _cell(context.tr("S.No"), headerStyle, flex: 1),
              _cell(context.tr("Price(Buffalo)"), headerStyle, flex: 2),
              _cell(context.tr("CPF(1 Year)"), headerStyle, flex: 2, center: true),
              _cell(context.tr("Total"), headerStyle, flex: 2, right: true),
            ],
          ),

          /// DYNAMIC ROWS
          ...rows.map((row) => _tableRow(
            context,
            bgColor: row.isFreeCpf ? const Color(0xFFF4FFFA) : const Color(0xFF10B981),
            isLast: rows.last == row,
            children: [
              _cell(
                row.serialNumber.toString(),
                TextStyle(color: row.isFreeCpf ? Colors.black : Colors.white),
                flex: 1,
              ),
              _cell(
                row.price.toString(),
                TextStyle(color: row.isFreeCpf ? Colors.black : Colors.white),
                flex: 2,
              ),
              if (row.isFreeCpf)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExactStrikeText(
                          text: "₹${row.insurance}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          strikeThickness: 2.2,
                          strikeColor: Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.tr("Free"),
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _cell(
                  row.insurance.toString(),
                  const TextStyle(color: Colors.white),
                  flex: 2,
                  center: true,
                ),
              _cell(
                row.total.toString(),
                TextStyle(color: row.isFreeCpf ? Colors.black : Colors.white),
                flex: 2,
                right: true,
              ),
            ],
          )),
        ],
      ),
    );
  }

  /// ===================== CELL =====================
  Widget _cell(
    String text,
    TextStyle style, {
    int flex = 1,
    bool center = false,
    bool right = false,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: center
            ? Alignment.center
            : right
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: style),
        ),
      ),
    );
  }

  Widget _tableRow(
    BuildContext context, {
    required List<Widget> children,
    bool isHeader = false,
    bool isLast = false,
    Color bgColor = Colors.transparent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isHeader
            ? const BorderRadius.vertical(top: Radius.circular(18))
            : isLast
                ? const BorderRadius.vertical(bottom: Radius.circular(18))
                : BorderRadius.zero,
      ),
      child: Row(children: children),
    );
  }
}

/// Model for Insurance Row
class InsuranceRow {
  final int serialNumber;
  final int price;
  final int insurance;
  final bool isFreeCpf;
  final int total;

  InsuranceRow({
    required this.serialNumber,
    required this.price,
    required this.insurance,
    required this.isFreeCpf,
    required this.total,
  });
}

/// Custom widget for strikethrough text
class ExactStrikeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double strikeThickness;
  final Color strikeColor;

  const ExactStrikeText({
    super.key,
    required this.text,
    required this.style,
    this.strikeThickness = 1.0,
    this.strikeColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(text, style: style),
        Positioned(
          top: style.fontSize! / 2,
          left: 0,
          right: 0,
          child: Container(
            height: strikeThickness,
            color: strikeColor,
          ),
        ),
      ],
    );
  }
}