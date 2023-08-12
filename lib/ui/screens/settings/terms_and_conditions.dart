import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';

import '../../../utils/colorPrefs.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/error_container.dart';
import '../../widgets/no_data_container.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});
  static Route<TermsAndConditions> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const TermsAndConditions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        title: Text(
          "termsCondition".translate(context: context),
          style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        elevation: 0,
        leading: UiUtils.setBackArrow(
          context,
        ),
      ),
      body: BlocBuilder<FetchSystemSettingsCubit, FetchSystemSettingsState>(
        builder: (context, state) {
          if (state is FetchSystemSettingsInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.headingFontColor,
              ),
            );
          }

          if (state is FetchSystemSettingsFailure) {
            return Center(
                child: ErrorContainer(
                    onTapRetry: () {
                      context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: false);
                    },
                    errorMessage: state.errorMessage.toString()));
          }
          if (state is FetchSystemSettingsSuccess) {
            if (state.termsAndConditions.isEmpty) {
              return NoDataContainer(titleKey: "noDataFound".translate(context: context));
            }
            return SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Text('klkl'),
            );
          }

          return Container();
        },
      ),
    );
  }
}
