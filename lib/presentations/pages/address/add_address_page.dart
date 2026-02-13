import 'package:epharmacy/data/models/address_model.dart';
import 'package:epharmacy/presentations/cubits/address/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _addressController.dispose();
    _houseNumberController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cityController,
                    keyboardType: TextInputType.streetAddress,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'City',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid city';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Address Invalid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _houseNumberController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.streetAddress,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'House Number',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.house,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid House Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _zipCodeController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Zip Code',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.code,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Zip Code Invalid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  BlocListener<AddressCubit, AddressState>(
                    listener: (context, state) {
                      if (state.status == AddressStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              state.errorMessage ?? 'Failed to add address',
                            ),
                          ),
                        );
                      }

                      if (state.status == AddressStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Succes to add address'),
                          ),
                        );
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddressCubit>().addAddress(
                            AddressModel(
                              address: _addressController.text.trim(),
                              city: _cityController.text.trim(),
                              houseNumber: _houseNumberController.text.trim(),
                              zipCode: int.parse(
                                _zipCodeController.text.trim(),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
