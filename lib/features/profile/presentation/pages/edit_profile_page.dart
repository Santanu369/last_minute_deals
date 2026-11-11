import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _selectedImage;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = 'Not Specified';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().loadProfile();
    final user = context.read<AuthCubit>().state.user;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? user.userName;
      _locationController.text = user.location ?? '';
      _postalCodeController.text = user.postalCode ?? '';
      _selectedGender = user.gender ?? 'Not Specified';
      if (user.dob != null && user.dob!.isNotEmpty) {
        try {
          final date = DateTime.parse(user.dob!);
          _dobController.text = DateFormat('dd-MM-yyyy').format(date);
        } catch (_) {
          _dobController.text = user.dob!;
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _postalCodeController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(_dobController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true;
    });

    String? apiDob;
    if (_dobController.text.isNotEmpty) {
      try {
        final parsedDate = DateFormat('dd-MM-yyyy').parse(_dobController.text);
        apiDob = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (_) {
        apiDob = _dobController.text;
      }
    }

    final user = context.read<AuthCubit>().state.user;

    final profileData = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'first_name': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
    };

    if (_selectedImage != null) {
      profileData['profileImageLocalPath'] = _selectedImage!.path;
    }

    final enteredLocation = _locationController.text.trim();
    if (enteredLocation != (user?.location ?? '')) {
      profileData['location'] = enteredLocation;
    }

    final enteredPostal = _postalCodeController.text.trim();
    if (enteredPostal != (user?.postalCode ?? '')) {
      profileData['postalCode'] = enteredPostal;
      profileData['postal_code'] = enteredPostal;
    }

    if (_selectedGender != (user?.gender ?? 'Not Specified')) {
      profileData['gender'] = _selectedGender;
    }

    if (apiDob != null && apiDob.isNotEmpty && apiDob != (user?.dob ?? '')) {
      profileData['dob'] = apiDob;
      profileData['dateOfBirth'] = apiDob;
      profileData['date_of_birth'] = apiDob;
    }

    final dbPhone = user?.phone ?? user?.userName ?? '';
    final enteredPhone = _phoneController.text.trim();
    if (enteredPhone.isNotEmpty && enteredPhone != dbPhone) {
      profileData['phone'] = enteredPhone;
      profileData['phoneNumber'] = enteredPhone;
      profileData['phone_number'] = enteredPhone;
      profileData['userName'] = enteredPhone;
    }

    final enteredEmail = _emailController.text.trim();
    if (enteredEmail.isNotEmpty && enteredEmail != (user?.email ?? '')) {
      profileData['email'] = enteredEmail;
    }

    final error = await context.read<AuthCubit>().updateProfile(profileData);

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TranslatedText(text: 'Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TranslatedText(text: error)),
        );
      }
    }
  }

  void _deleteProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TranslatedText(text: 'Delete Profile'),
        content: const TranslatedText(
            text: 'Are you sure you want to delete your profile? This action is permanent and cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TranslatedText(text: 'Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle deletion logic or show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: TranslatedText(text: 'Profile deletion request submitted.')),
              );
            },
            child: const TranslatedText(text: 'Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final user = context.watch<AuthCubit>().state.user;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'RedHatDisplay',
        ),
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          final user = state.user;
          if (user != null) {
            if (_firstNameController.text != user.firstName) {
              _firstNameController.text = user.firstName;
            }
            if (_lastNameController.text != user.lastName) {
              _lastNameController.text = user.lastName;
            }
            if (_emailController.text != user.email) {
              _emailController.text = user.email;
            }
            final expectedPhone = user.phone ?? user.userName;
            if (_phoneController.text != expectedPhone) {
              _phoneController.text = expectedPhone;
            }
            final expectedLocation = user.location ?? '';
            if (_locationController.text != expectedLocation) {
              _locationController.text = expectedLocation;
            }
            final expectedPostalCode = user.postalCode ?? '';
            if (_postalCodeController.text != expectedPostalCode) {
              _postalCodeController.text = expectedPostalCode;
            }
            final expectedGender = user.gender ?? 'Not Specified';
            if (_selectedGender != expectedGender) {
              setState(() {
                _selectedGender = expectedGender;
              });
            }
            if (user.dob != null && user.dob!.isNotEmpty) {
              try {
                final date = DateTime.parse(user.dob!);
                final expectedDob = DateFormat('dd-MM-yyyy').format(date);
                if (_dobController.text != expectedDob) {
                  _dobController.text = expectedDob;
                }
              } catch (_) {
                if (_dobController.text != user.dob!) {
                  _dobController.text = user.dob!;
                }
              }
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: TranslatedText(
              text: 'Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: _isSaving
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: _selectedImage != null
                                      ? CircleAvatar(
                                          radius: 54,
                                          backgroundImage: FileImage(_selectedImage!),
                                        )
                                      : UserAvatar(
                                          imageUrl: user?.profileImage,
                                          name: user?.firstName ?? '',
                                          radius: 54,
                                          size: 40.r,
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF97316), // Orange
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 18.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: TranslatedText(
                            text:'${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.grey, size: 16.r),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: TranslatedText(
                                text: user?.location ?? 'Not Specified',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        const Divider(color: Color(0xFFE5E7EB)),
                        SizedBox(height: 20.h),

                        // Form Fields
                        _buildTextField(
                          label: 'Name',
                          controller: _firstNameController,
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          label: 'Full Name',
                          controller: _lastNameController,
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          label: 'Email Address',
                          controller: _emailController,
                          readOnly: true,
                          showVerifiedBadge: user?.isEmailVerified ?? false,
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          label: 'Phone Number',
                          controller: _phoneController,
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          label: 'Location',
                          controller: _locationController,
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          label: 'Postal Code',
                          controller: _postalCodeController,
                        ),
                        SizedBox(height: 20.h),

                        // Custom Date of Birth input field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TranslatedText(
                              text: 'Date of Birth',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TranslatedText(
                                      text: _dobController.text.isEmpty ? 'dd-mm-yyyy' : _dobController.text,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: _dobController.text.isEmpty
                                            ? const Color(0xFF9CA3AF)
                                            : Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.black,
                                      size: 20.r,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Gender Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TranslatedText(
                              text: 'Gender',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGender,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'Not Specified', child: Text('Not Specified')),
                                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedGender = val ?? 'Not Specified';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _deleteProfile,
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                              label:  TranslatedText (
                                text:'Delete Profile',
                                style: TextStyle(
                                  color: Color(0xFFE11D48),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF1F2),
                                side: const BorderSide(color: Color(0xFFFECDD3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                                elevation: 0,
                              ),
                              child: TranslatedText(
                                text: 'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mediaQuery.padding.bottom + 20),
                      ],
                    ),
                  ),
                ),
              ),
      )),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool showVerifiedBadge = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          text: label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            color: readOnly ? Colors.black.withValues(alpha: 0.6) : Colors.black,
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            suffixIcon: showVerifiedBadge
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: Color(0xFF059669), size: 12.r),
                            SizedBox(width: 4.w),
                            TranslatedText(
                              text: 'Verified',
                              style: TextStyle(
                                color: Color(0xFF059669),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
