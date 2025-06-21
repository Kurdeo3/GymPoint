import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart';
import 'package:flutter_application_tugasbesar/view/optionMenu.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends ConsumerStatefulWidget {
  final Map<String, dynamic> formData;  

  const ProfileView({super.key, required this.formData});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _isEditing = false;
  bool _isEditActive = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedGender;
  File? _profileImage;
  
  final userProvider = FutureProvider<User>((ref) async {
    return await UserClient.getCurrentUser();
  });

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.formData['nama'] ?? '';
    _emailController.text = widget.formData['email'] ?? '';
    _selectedGender = widget.formData['jenisKelamin'] ?? '';
    _ageController.text = widget.formData['umur']?.toString() ?? '';
    _phoneController.text = widget.formData['noTelp'] ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        print('Gambar dipilih: ${_profileImage!.path}');
      });

      await _uploadProfilePicture();  
    }else {
      print('Tidak ada gambar yang dipilih');
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_profileImage == null) {
        return; 
    }

    try {
        await UserClient.uploadProfilePicture(_profileImage!);
        await ref.refresh(userProvider.future);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gambar profil berhasil diperbarui')),
        );
    } catch (e) {
        _showErrorDialog('Gagal mengupload gambar profil: $e');
    }
}

  void _toggleEdit() {
    String? validationMessage = _validateFields();
    if (_isEditing && validationMessage != null) {
      _showErrorDialog(validationMessage);
      return;
    }

    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _isEditActive = true;
      } else {
        _saveChanges();
        _isEditActive = false;
      }
    });
  }

  void _saveChanges() async {
    try {
      final userAsync = await ref.read(userProvider.future);

      User updatedUser = User(
        nama: _nameController.text,
        email: _emailController.text,
        jenisKelamin: _selectedGenderNonNull,
        umur: int.parse(_ageController.text),
        noTelp: _phoneController.text,
        username: userAsync.username,
        password: userAsync.password,
        profilePicture: userAsync.profilePicture,
      );

      await UserClient.update(updatedUser);

      ref.refresh(userProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      _showErrorDialog('Gagal memperbarui profil: $e');
    }
  }

  String get _selectedGenderNonNull => _selectedGender ?? ''; 

  String? _validateFields() {
    if (_nameController.text.isEmpty) {
      return 'Nama Tidak boleh kosong';
    }
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      return 'Email Tidak valid';
    }
    if (_selectedGender == null || _selectedGender!.isEmpty) {
      return 'Jenis Kelamin Tidak boleh kosong';
    }
    if (_ageController.text.isEmpty || int.tryParse(_ageController.text) == null) {
      return 'Umur Tidak valid';
    }
    if (_phoneController.text.isEmpty || !_isPhoneNumberValid(_phoneController.text)) {
      return 'Nomor Telepon harus berupa angka';
    }
    return null;
  }

  bool _isPhoneNumberValid(String phone) {
    return RegExp(r'^[+]?\d{1,15}$').hasMatch(phone);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kesalahan'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileItem(
    String label, TextEditingController controller, bool isEditing,
    {bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            if (label == 'Nama' && !isEditing)
              GestureDetector(
                onTap: _toggleEdit,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Edit',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        isEditing
            ? TextField(
                controller: controller,
                keyboardType:
                    isPhone ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Masukkan $label',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              )
            : Text(
                controller.text,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
        const Divider(color: Colors.white, thickness: 1),
      ],
    );
  }

  Widget _buildGenderItem(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          _selectedGender ?? 'Jenis kelamin tidak tersedia',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const Divider(color: Colors.white, thickness: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: userAsync.when( 
        data: (user) {
        print('Profile Image: ${_profileImage?.path}');
        print('User  Profile Picture: ${user.profilePicture}');

          _nameController.text = user.nama;
          _emailController.text = user.email;
          _selectedGender = user.jenisKelamin;
          _ageController.text = user.umur.toString();
          _phoneController.text = user.noTelp;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) 
                          : user.profilePicture != null
                              ? NetworkImage('http://10.0.2.2:8000/${user.profilePicture}')
                              : null,
                      backgroundColor: Colors.grey[300],
                      child: _profileImage == null && user.profilePicture == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[700],
                            )
                          : null,
                    ),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo, color: Colors.white),
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Select from Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Select from Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.cancel),
                                      title: const Text('Cancel'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProfileItem('Nama', _nameController, _isEditing),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProfileItem('Email', _emailController, _isEditing),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildGenderItem('Jenis Kelamin'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProfileItem('Umur', _ageController, _isEditing),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProfileItem(
                        'No Telp', _phoneController, _isEditing,
                        isPhone: true),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: _isEditActive ? _toggleEdit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Simpan' : 'Edit',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await UserClient.logout(UserClient.token!);
                          UserClient.token = null;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OptionMenu(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout gagal: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}