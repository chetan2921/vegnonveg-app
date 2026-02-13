import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _paymentMethod = 'cod';
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == 2 ? 'PLACE ORDER' : 'CONTINUE'),
              ),
              if (_currentStep > 0) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('BACK'),
                ),
              ],
            ],
          );
        },
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep = 1);
            }
          } else if (_currentStep == 1) {
            setState(() => _currentStep = 2);
          } else {
            _placeOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep -= 1);
        },
        steps: [
          Step(
            title: const Text(
              'Shipping Address',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildAddressForm(),
          ),
          Step(
            title: const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildPaymentSelection(),
          ),
          Step(
            title: const Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            isActive: _currentStep >= 2,
            content: _buildOrderSummary(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: Validators.name,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address1Controller,
            decoration: const InputDecoration(labelText: 'Address Line 1'),
            validator: (v) => Validators.required(v, fieldName: 'Address'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2 (Optional)',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => Validators.required(v, fieldName: 'City'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (v) => Validators.required(v, fieldName: 'State'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _pincodeController,
            decoration: const InputDecoration(labelText: 'Pin Code'),
            keyboardType: TextInputType.number,
            validator: Validators.pinCode,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPaymentSelection() {
    return Column(
      children: [
        _PaymentOption(
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive',
          icon: Icons.money,
          value: 'cod',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
        _PaymentOption(
          title: 'UPI',
          subtitle: 'Google Pay, PhonePe, BHIM',
          icon: Icons.qr_code,
          value: 'upi',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
        _PaymentOption(
          title: 'Debit / Credit Card',
          subtitle: 'Visa, Mastercard, RuPay',
          icon: Icons.credit_card,
          value: 'card',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
        _PaymentOption(
          title: 'Net Banking',
          subtitle: 'All major banks',
          icon: Icons.account_balance,
          value: 'netbanking',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final cart = context.watch<CartProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items summary
        ...cart.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.product.name} (${item.selectedSize}) x${item.quantity}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Text(
                  Formatters.currency(item.totalPrice),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
        const Divider(),
        _SummaryRow('Subtotal', Formatters.currency(cart.subtotal)),
        if (cart.discount > 0)
          _SummaryRow('Discount', '-${Formatters.currency(cart.discount)}'),
        _SummaryRow(
          'Shipping',
          cart.hasFreeShipping ? 'FREE' : Formatters.currency(cart.shipping),
        ),
        _SummaryRow('Tax', Formatters.currency(cart.tax)),
        const Divider(),
        _SummaryRow('Total', Formatters.currency(cart.total), isBold: true),
        const SizedBox(height: 8),
        Text(
          'Delivering to: ${_nameController.text}, ${_address1Controller.text}, ${_cityController.text}',
          style: const TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
        const SizedBox(height: 4),
        Text(
          'Payment: ${_paymentMethod.toUpperCase()}',
          style: const TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _placeOrder() {
    final cart = context.read<CartProvider>();
    // Simulate order placement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.discount, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Order Placed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${Formatters.currency(cart.total)}',
              style: const TextStyle(fontSize: 16, color: AppColors.grey600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                cart.clear();
                Navigator.pop(ctx);
                context.go('/home');
              },
              child: const Text('CONTINUE SHOPPING'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey700),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
      activeColor: AppColors.primaryBlack,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
