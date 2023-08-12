import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/app/appTheme.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/delete_account_cubit.dart';
import 'package:edemand_partner/data/cubits/signIn_cubit.dart';
import 'package:edemand_partner/data/cubits/user_info_cubit.dart';
import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:edemand_partner/ui/screens/booking_screen.dart';
import 'package:edemand_partner/ui/screens/reviews_screen.dart';
import 'package:edemand_partner/ui/screens/services/services_screen.dart';
import 'package:edemand_partner/ui/widgets/bottomSheets/changePassword.dart';
import 'package:edemand_partner/ui/widgets/bottomSheets/chooseLangagueBottomSheet.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/Notification/awsomeNotification.dart';
import 'package:edemand_partner/utils/Notification/notificationService.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/dialogs.dart';
import 'package:edemand_partner/utils/hive_utils.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/appThemeCubit.dart';
import '../../utils/colorPrefs.dart';
import '../../utils/uiUtils.dart';
import 'home_screen.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  State<MainActivity> createState() => MainActivityState();

  static Route<MainActivity> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const MainActivity(),
    );
  }
}

class MainActivityState extends State<MainActivity> with TickerProviderStateMixin {
  final TextEditingController _passwordControllerDeleteAccount = TextEditingController();
  GlobalKey<FormState> deleteAccountFormKey = GlobalKey();
  int currtab = 0;
  String currTabTitle = "";

  late PageController pageController;

  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
    LocalAwsomeNotification().init(context);
    NotificationService.init(context);

    Future.delayed(Duration.zero).then((value) {
      currTabTitle = "homeTabTitleLbl".translate(context: context);
      try {
        context.read<UserInfoCubit>().setUserInfo(HiveUtils.getProviderDetails());
      } catch (_) {}
    });

    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  List<Widget> pages = [
    const HomeScreen(),
    const BookingScreen(),
    const ServicesScreen(),
    const ReviewsScreen(),
  ];

  _getUserName() {
    return context.watch<UserInfoCubit>().providerDetails.user?.username ?? "";
  }

  _getEmail() {
    return context.watch<UserInfoCubit>().providerDetails.user?.email ?? "";
  }

  getProfileImage() {
    return CachedNetworkImageProvider(
        context.watch<UserInfoCubit>().providerDetails.user?.image ?? "");
  }

  bool doUserHasProfileImage() {
    return context.watch<UserInfoCubit>().providerDetails.user?.image != "";
  }

  _getPlaceHolderProfileImage() {
    return UiUtils.setSVGImage(
      'myProfile',
    );
  }

  _deleteProviderAccount() async {
    var passwordPromptDialoge = BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacementNamed(context, Routes.loginScreenRoute);
          }
        },
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (c, state) {
            if (state is SignInSuccess) {
              context.read<DeleteAccountCubit>().deleteAccount();
            }
          },
          builder: (context, state) {
            return CustomDialogs.showTextFieldDialoge(context,
                controller: _passwordControllerDeleteAccount,
                formKey: deleteAccountFormKey,
                title: "deleteAccount".translate(context: context),
                message: (state is SignInFailure) ? (state).errorMessage : "",
                confirmButtonName: "deleteBtnLbl".translate(context: context),
                showProgress: (state is SignInInProgress),
                progressColor: Theme.of(context).colorScheme.blackColor,
                confirmButtonColor: Colors.red, onConfirmed: () async {
              //
              String countryCode =
                  context.read<UserInfoCubit>().providerDetails.user?.countryCode ?? "";
              String mobileNumber = context.read<UserInfoCubit>().providerDetails.user?.phone ?? "";

              if (_passwordControllerDeleteAccount.text.trim().isEmpty) {
                UiUtils.showMessage(
                    context, "enterYourPasswrd".translate(context: context), MessageType.error);
                return;
              }
              if (Constant.isDemoModeEnable) {
                UiUtils.showMessage(
                    context, "demoModeWarning".translate(context: context), MessageType.warning);
                Navigator.pop(context);
                return;
              }
              context.read<SignInCubit>().SignIn(
                  phoneNumber: mobileNumber,
                  password: _passwordControllerDeleteAccount.text.trim(),
                  countryCode: countryCode);
            }, onCancled: () {
              context.read<SignInCubit>().setInitial();
            });
          },
        ),
      ),
    );

    var confirmDialoge = CustomDialogs.showConfirmDialoge(
        context: context,
        title: "deleteAccount".translate(context: context),
        description: "deleteAcountDescription".translate(context: context),
        confirmButtonName: "Delete",
        confirmTextColor: Theme.of(context).colorScheme.secondaryColor,
        confirmButtonColor: Theme.of(context).colorScheme.headingFontColor,
        onConfirmed: () async {
          Navigator.pop(context);
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return passwordPromptDialoge;
            },
          );
          _passwordControllerDeleteAccount.text = "";
        },
        onCancled: () {});

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialoge;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    darkTheme = (context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (currtab != 0) {
              setState(() {
                currtab = 0;
              });
              pageController.jumpToPage(currtab);
              return false;
            }
            return true;
          },
          child: Scaffold(
              bottomNavigationBar: bottomBar(),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.blackColor),
                title: Text(currTabTitle,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor)), //set according to tab
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onDrawerChanged: (a) {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).unfocus();
              },
              drawer: drawer(),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: onItemTapped,
                children: pages,
              )),
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();

    switch (index) {
      case 1:
        currTabTitle = "bookingsTitleLbl".translate(context: context);
        break;
      case 2:
        currTabTitle = "servicesTitleLbl".translate(context: context);
        break;
      case 3:
        currTabTitle = "reviewsTitleLbl".translate(context: context);
        break;
      default: //index = 0
        currTabTitle = "homeTabTitleLbl".translate(context: context);
        break;
    }
    setState(() {
      currtab = index;
    });
    pageController.jumpToPage(currtab);
  }

  Widget drawer() {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      child: ListView(
        padding: const EdgeInsets.all(0),
        physics: const ClampingScrollPhysics(),
        children: [
          DrawerHeader(
            //set all header details according to loggedIn user details
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.headingFontColor,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.registration, arguments: {"isEditing": true});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Theme.of(context).colorScheme.blackColor,
                      backgroundImage: doUserHasProfileImage() ? getProfileImage() : null,
                      child: doUserHasProfileImage() ? null : _getPlaceHolderProfileImage()),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            titleText: _getUserName(),
                            fontColor: ColorPrefs.whiteColors,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700),
                        CustomText(
                          titleText: "${_getEmail()}",
                          fontColor: ColorPrefs.whiteColors,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: ColorPrefs.whiteColors.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Icon(Icons.edit, color: ColorPrefs.whiteColors, size: 16),
                  ),
                ],
              ),
            ),
          ),
          buildDrawerItem(
              icon: 'categories',
              title: "categoriesLbl".translate(context: context),
              onItemTap: () {
                Navigator.of(context).pop();
                UiUtils.pushtoNextScreen(Routes.categories, context);
              }),
          buildDrawerItem(
              icon: 'promoCode',
              title: "promoCodeLbl".translate(context: context),
              onItemTap: () {
                Navigator.of(context).pop();
                UiUtils.pushtoNextScreen(Routes.promoCode, context);
              }),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          buildGroupTitle("appPrefsTitleLbl".translate(context: context)),

          buildDrawerItem(
              icon: 'language',
              title: "languageLbl".translate(context: context),
              onItemTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                  builder: (context) {
                    return const ChooseLanguageBottomSheet();
                  },
                );
              }),
          buildDrawerItem(
              icon: 'darkMode',
              title: "darkThemeLbl".translate(context: context),
              isSwitch: true,
              onItemTap: () {
                context.read<AppThemeCubit>().toggleTheme();
                darkTheme = context.read<AppThemeCubit>().isDarkMode();
                setState(() {});
              }),
          buildDrawerItem(
              icon: 'change_password',
              title: "changePassword".translate(context: context),
              onItemTap: () async {
                /*   UiUtils.showBottomSheet(
                  enableDrag: true,
                  context: context,
                  child: ChangePasswordBottomSheet(),
                );
                return;*/
                await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                  ),
                  enableDrag: true,
                  isScrollControlled: true,
                  builder: (context) => Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const ChangePasswordBottomSheet()),
                );
              }),
          buildDrawerItem(
              icon: 'commission_settlement',
              title: "withdrawalRequest".translate(context: context),
              onItemTap: () {
                Navigator.of(context).pop();
                UiUtils.pushtoNextScreen(Routes.withdrawalRequests, context);
              }),
          // buildDrawerItem(
          //     icon: 'transactions',
          //     title: UiUtils.getTranslatedLabel(context, "transactionsLbl"),
          //     onItemTap: () {
          //       Navigator.of(context).pop();
          //       UiUtils.pushtoNextScreen(Routes.transactions, context);
          //     }),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          buildGroupTitle("helpPrivacyTitleLbl".translate(context: context)),
          buildDrawerItem(
              icon: 'contact',
              title: "contactUs".translate(context: context),
              onItemTap: () {
                Navigator.pushNamed(context, Routes.contactUs);
              }),
          buildDrawerItem(
              icon: 'help',
              title: "aboutUs".translate(context: context),
              onItemTap: () {
                Navigator.pushNamed(context, Routes.aboutUs);
              }),
          buildDrawerItem(
            icon: 'privacy_policy',
            title: "privacyPolicyLbl".translate(context: context),
            onItemTap: () {
              Navigator.pushNamed(context, Routes.pricacyPolicy);
            },
          ),
          buildDrawerItem(
              icon: 'terms',
              title: "termsConditionLbl".translate(context: context),
              onItemTap: () {
                Navigator.pushNamed(context, Routes.termsConditions);
              }),
          buildDrawerItem(
              icon: 'logout',
              title: "logoutLbl".translate(context: context),
              onItemTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogs.showConfirmDialoge(
                        context: context,
                        title: "logoutLbl".translate(context: context),
                        cancleButtonName: "cancel".translate(context: context),
                        confirmButtonName: "logoutLbl".translate(context: context),
                        confirmButtonColor: Colors.black,
                        description: "areYouSureLogout".translate(context: context),
                        onConfirmed: () async {
                          await AuthRepository().logout(context);
                          // await HiveUtils.logoutUser();
                        },
                        onCancled: () {});
                  },
                );
              }),

          ListTile(
            tileColor: Colors.redAccent.withOpacity(0.05),

            visualDensity: const VisualDensity(vertical: -4),
            //change -4 to required one TO INCREASE SPACE BTWN ListTiles
            leading: const Icon(Icons.delete, color: Colors.red),
            title: CustomText(
              titleText: "deleteAccount".translate(context: context),
              textAlign: TextAlign.start,
              fontSize: 15.0,
              fontColor: Colors.red,
            ),
            selectedTileColor: Theme.of(context).colorScheme.lightGreyColor,
            onTap: () async {
              await _deleteProviderAccount();
            },
            hoverColor: Theme.of(context).colorScheme.lightGreyColor,
            horizontalTitleGap: 0,
          )
        ],
      ),
    );
  }

  Widget buildGroupTitle(String titleTxt) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 10, bottom: 10),
      child: CustomText(
        titleText: titleTxt,
        fontSize: 14,
        fontColor: Theme.of(context).colorScheme.lightGreyColor,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget buildDrawerItem(
      {required String? icon,
      required String title,
      required VoidCallback onItemTap,
      bool? isSwitch}) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      //change -4 to required one TO INCREASE SPACE BTWN ListTiles
      leading: UiUtils.setSVGImage(icon!,
          imgColor: (title == "logoutLbl".translate(context: context))
              ? ColorPrefs.redColor
              : Theme.of(context).colorScheme.blackColor),
      trailing: isSwitch ?? false
          ? CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.headingFontColor,
              value: darkTheme,
              onChanged: (val) {
                setState(() {
                  darkTheme = !darkTheme;
                });
                onItemTap.call();
              })
          : const SizedBox.shrink(),
      title: CustomText(
        titleText: title,
        textAlign: TextAlign.start,
        // fontWeight: (icon != null && icon != '') ? FontWeight.w500 : FontWeight.normal,
        fontSize: 15.0,
        fontColor: (title == "logoutLbl".translate(context: context))
            ? ColorPrefs.redColor
            : Theme.of(context).colorScheme.blackColor,
      ),
      selectedTileColor: Theme.of(context).colorScheme.lightGreyColor,
      onTap: onItemTap,
      hoverColor: Theme.of(context).colorScheme.lightGreyColor,
      horizontalTitleGap: 0,
    );
  }

  bottomBar() {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.secondaryColor,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              setBottomNavigationbarItem(0, 'home', "homeTab".translate(context: context)),
              setBottomNavigationbarItem(1, 'booking', "bookingTab".translate(context: context)),
              setBottomNavigationbarItem(2, 'services', "serviceTab".translate(context: context)),
              setBottomNavigationbarItem(3, 'reviews', "reviewsTab".translate(context: context))
            ]),
      ),
    );
  }

  Widget setBottomNavigationbarItem(int index, String imgName, String nameTxt) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => onItemTapped(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsetsDirectional.only(top: 8),
                  child: UiUtils.setSVGImage(imgName,
                      imgColor: currtab != index
                          ? Theme.of(context).colorScheme.lightGreyColor
                          : Theme.of(context).colorScheme.accentColor)),
              CustomText(
                  titleText: nameTxt,
                  fontSize: 12,
                  fontColor: (currtab == index)
                      ? Theme.of(context).colorScheme.accentColor
                      : Theme.of(context).colorScheme.lightGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}
