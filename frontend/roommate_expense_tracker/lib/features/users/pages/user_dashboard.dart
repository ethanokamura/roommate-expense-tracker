import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String nickname = "John Doe";
  String paymentMethod = "Venmo";
  String paymentLink = "@johndoe";
  
  bool isEditingNickname = false;
  bool isEditingPaymentMethod = false;
  bool isEditingPaymentLink = false;
  
  late TextEditingController nicknameController;
  late TextEditingController paymentMethodController;
  late TextEditingController paymentLinkController;

  // Mock data - replace with your house-members API
  List<Map<String, dynamic>> userHouses = [
    {
      'house_id': '1',
      'house_name': 'Cool House',
      'role': 'head_of_house',
      'member_count': 4,
    },
    {
      'house_id': '2', 
      'house_name': 'Beach House',
      'role': 'member',
      'member_count': 3,
    }
  ];

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(text: nickname);
    paymentMethodController = TextEditingController(text: paymentMethod);
    paymentLinkController = TextEditingController(text: paymentLink);
  }

  @override
  void dispose() {
    nicknameController.dispose();
    paymentMethodController.dispose();
    paymentLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            
            const VerticalBar(),
            
            // Nickname Section (simple style)
            _buildNicknameSection(context),
            
            const VerticalBar(),
            
            // Payment Method Section
            _buildPaymentMethodSection(context),
            
            const VerticalBar(),
            
            // Payment Link Section
            _buildPaymentLinkSection(context),
            
            const VerticalBar(),
            
            // Houses Section (with dashboard buttons)
            _buildHousesSection(context),
            
            const VerticalBar(),
            
            // Logout Button
            _buildLogoutButton(context),
            
            const VerticalSpacer(multiple: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome back, $nickname!',
            style: AppTextStyles.appBar,
            color: context.theme.accentColor,
          ),
          const VerticalSpacer(),
          CustomText(
            text: 'You\'re part of ${userHouses.length} house${userHouses.length == 1 ? '' : 's'}',
            style: AppTextStyles.secondary,
            color: context.theme.subtextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          CustomText(
            text: 'Nickname: ',
            style: AppTextStyles.primary,
          ),
          Expanded(
            child: isEditingNickname
                ? customTextFormField(
                    context: context,
                    label: '',
                    controller: nicknameController,
                    onBackground: false,
                  )
                : CustomText(
                    text: nickname,
                    style: AppTextStyles.primary,
                  ),
          ),
          const HorizontalSpacer(),
          GestureDetector(
            onTap: () {
              if (isEditingNickname) {
                // Save nickname
                setState(() {
                  nickname = nicknameController.text;
                  isEditingNickname = false;
                });
                _saveNickname(nickname);
              } else {
                // Start editing
                setState(() {
                  isEditingNickname = true;
                });
              }
            },
            child: Icon(
              isEditingNickname ? Icons.check : Icons.edit,
              color: context.theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          CustomText(
            text: 'Pref. Payment Method: ',
            style: AppTextStyles.primary,
          ),
          Expanded(
            child: isEditingPaymentMethod
                ? customTextFormField(
                    context: context,
                    label: '',
                    controller: paymentMethodController,
                    onBackground: false,
                  )
                : CustomText(
                    text: paymentMethod.isEmpty ? 'Not set' : paymentMethod,
                    style: AppTextStyles.primary,
                    color: paymentMethod.isEmpty 
                        ? context.theme.subtextColor 
                        : null,
                  ),
          ),
          const HorizontalSpacer(),
          GestureDetector(
            onTap: () {
              if (isEditingPaymentMethod) {
                // Save payment method
                setState(() {
                  paymentMethod = paymentMethodController.text;
                  isEditingPaymentMethod = false;
                });
                _savePaymentMethod(paymentMethod);
              } else {
                // Start editing
                setState(() {
                  isEditingPaymentMethod = true;
                });
              }
            },
            child: Icon(
              isEditingPaymentMethod ? Icons.check : Icons.edit,
              color: context.theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLinkSection(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          CustomText(
            text: 'Link: ',
            style: AppTextStyles.primary,
          ),
          Expanded(
            child: isEditingPaymentLink
                ? customTextFormField(
                    context: context,
                    label: '',
                    controller: paymentLinkController,
                    onBackground: false,
                  )
                : CustomText(
                    text: paymentLink.isEmpty ? 'Not set' : paymentLink,
                    style: AppTextStyles.primary,
                    color: paymentLink.isEmpty 
                        ? context.theme.subtextColor 
                        : null,
                  ),
          ),
          const HorizontalSpacer(),
          GestureDetector(
            onTap: () {
              if (isEditingPaymentLink) {
                // Save payment link
                setState(() {
                  paymentLink = paymentLinkController.text;
                  isEditingPaymentLink = false;
                });
                _savePaymentLink(paymentLink);
              } else {
                // Start editing
                setState(() {
                  isEditingPaymentLink = true;
                });
              }
            },
            child: Icon(
              isEditingPaymentLink ? Icons.check : Icons.edit,
              color: context.theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHousesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Houses:',
          style: AppTextStyles.primary,
        ),
        const VerticalSpacer(),
        ...userHouses.map((house) => _buildHouseCard(context, house)).toList(),
      ],
    );
  }

  Widget _buildHouseCard(BuildContext context, Map<String, dynamic> house) {
    return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: DefaultContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: house['house_name'],
                    style: AppTextStyles.title,
                  ),
                ),
                if (house['role'] != 'head_of_house')
                  GestureDetector(
                    onTap: () => _leaveHouse(house['house_id']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: defaultBorderRadius,
                      ),
                      child: const CustomText(
                        text: 'leave button',
                        style: AppTextStyles.secondary,
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  CustomTag(
                    text: 'Head',
                    color: context.theme.accentColor,
                  ),
              ],
            ),
            const VerticalSpacer(),
            Row(
              children: [
                Icon(
                  AppIcons.user,
                  size: 16,
                  color: context.theme.subtextColor,
                ),
                const HorizontalSpacer(multiple: 0.5),
                CustomText(
                  text: '${house['member_count']} members',
                  style: AppTextStyles.secondary,
                  color: context.theme.subtextColor,
                ),
              ],
            ),
            const VerticalSpacer(),
            CustomButton(
              text: 'View House Dashboard',
              onTap: () => _navigateToHouseDashboard(house['house_id']),
              color: context.theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Logout',
        onTap: _logout,
        color: context.theme.primaryColor,
      ),
    );
  }

  // API Integration Methods
  void _saveNickname(String newNickname) {
    // TODO: Call API to update user nickname
    // PATCH /users/:id with {"nickname": newNickname}
    print('Saving nickname: $newNickname');
  }

  void _savePaymentMethod(String newPaymentMethod) {
    // TODO: Call API to update user payment method
    // PATCH /users/:id with {"payment_method": newPaymentMethod}
    print('Saving payment method: $newPaymentMethod');
  }

  void _savePaymentLink(String newPaymentLink) {
    // TODO: Call API to update user payment link
    // PATCH /users/:id with {"payment_link": newPaymentLink}
    print('Saving payment link: $newPaymentLink');
  }

  void _leaveHouse(String houseId) {
    // TODO: Call your house-members DELETE API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: CustomText(
          text: 'Leave House',
          style: AppTextStyles.title,
        ),
        content: const CustomText(
          text: 'Are you sure you want to leave this house?',
          style: AppTextStyles.primary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Cancel',
              style: AppTextStyles.secondary,
            ),
          ),
          TextButton(
            onPressed: () {
              // Call DELETE /house-members/:id API  
              Navigator.pop(context);
              setState(() {
                userHouses.removeWhere((house) => house['house_id'] == houseId);
              });
            },
            child: const CustomText(
              text: 'Leave',
              style: AppTextStyles.primary,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHouseDashboard(String houseId) {
    // Navigate to house-specific dashboard
    print('Navigate to house dashboard: $houseId');
  }

  void _logout() {
    // TODO: Clear auth and navigate to login
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: CustomText(
          text: 'Logout',
          style: AppTextStyles.title,
        ),
        content: const CustomText(
          text: 'Are you sure you want to logout?',
          style: AppTextStyles.primary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Cancel',
              style: AppTextStyles.secondary,
            ),
          ),
          TextButton(
            onPressed: () {
              // Clear auth and navigate to login
              Navigator.pop(context);
              print('Logging out...');
            },
            child: const CustomText(
              text: 'Logout',
              style: AppTextStyles.primary,
            ),
          ),
        ],
      ),
    );
  }
}
