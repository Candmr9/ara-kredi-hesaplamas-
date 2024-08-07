import 'package:flutter/material.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with SingleTickerProviderStateMixin {
  final _carPriceController = TextEditingController();
  final _monthsController = TextEditingController();
  final _interestRateController = TextEditingController();
  double? _monthlyPayment;
  double? _totalPayment;
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _carPriceController.dispose();
    _monthsController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _calculate() {
    final carPrice = double.tryParse(_carPriceController.text);
    final months = int.tryParse(_monthsController.text);
    final annualInterestRate = double.tryParse(_interestRateController.text);

    if (carPrice != null && months != null && annualInterestRate != null) {
      final monthlyRate = (annualInterestRate / 100) / 12; // Yıllık faiz oranını aylık faiz oranına çeviriyoruz.
      
      // Amortisman formülü ile aylık ödeme miktarını hesaplıyoruz.
      final monthlyPayment = carPrice * (monthlyRate * pow(1 + monthlyRate, months)) / (pow(1 + monthlyRate, months) - 1);

      // Toplam ödeme miktarını hesaplıyoruz.
      final totalAmount = monthlyPayment * months;

      setState(() {
        _monthlyPayment = monthlyPayment;
        _totalPayment = totalAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Kredi Hesaplayıcı'),
      ),
      body: content(),
    );
  }

  Widget content() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple, Colors.blue],
              stops: [
                0.0,
                0.5 + 0.5 * sin(_animation.value),
                1.0,
              ],
              transform: GradientRotation(_animation.value),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.asset("assets/car.jpg", fit: BoxFit.cover),
              ),
              Transform(
                transform: Matrix4.translationValues(0, -30, 0),
                child: Text(
                  "Hesap Makinesi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _carPriceController,
                labelText: 'Kredi Miktarı',
                icon: Icons.attach_money,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _monthsController,
                labelText: 'Vade Süresi (Aylık)',
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _interestRateController,
                labelText: 'Faiz Oranı (%)',
                icon: Icons.percent,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Hesapla'),
              ),
              SizedBox(height: 20),
              if (_monthlyPayment != null && _totalPayment != null)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Aylık Ödeme',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${_monthlyPayment!.toStringAsFixed(2)} TL',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Toplam Geri Ödeme',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${_totalPayment!.toStringAsFixed(2)} TL',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            hintText: labelText,
          ),
        ),
      ),
    );
  }
}
