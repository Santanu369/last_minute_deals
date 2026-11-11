import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/services/lanrepos.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/language/model/lan_model.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  final TextEditingController searchController = TextEditingController();
  final LanguageRepository repository = LanguageRepository();

  List<LanguageModel> languages = [];
  List<LanguageModel> filteredLanguages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguages() async {
    try {
      final result = await repository.getLanguages();
      if (!mounted) return;
      setState(() {
        languages = result;
        filteredLanguages = result;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('language_load_error'.tr())));
    }
  }

  void _search(String value) {
    final query = value.toLowerCase();
    setState(() {
      filteredLanguages =
          languages.where((l) => l.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = context.locale.languageCode;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DS.maxWidth),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(DS.screenPadding.w),
                  child: Text('select_language'.tr(),
                      style: DS.ts(20, FontWeight.w700, DS.textPrimary)),
                ),

                // Search input (56px, 12px radius)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w),
                  child: Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: DS.card,
                      borderRadius: BorderRadius.circular(DS.radiusInput.r),
                      border: Border.all(color: DS.borderMedium),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _search,
                      style: DS.ts(14, FontWeight.w400, DS.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'search'.tr(),
                        hintStyle: DS.ts(14, FontWeight.w400, DS.textTertiary),
                        prefixIcon: Icon(Icons.search, color: DS.textSecondary, size: 20.r),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                Expanded(
                  child: loading
                      ? const Center(
                      child: CircularProgressIndicator(color: DS.primaryBlue))
                      : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                        DS.screenPadding.w, 0, DS.screenPadding.w, DS.screenPadding.h),
                    itemCount: filteredLanguages.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final language = filteredLanguages[index];
                      final isSelected = language.code == selectedLanguage;

                      return InkWell(
                        borderRadius: BorderRadius.circular(DS.radiusCard.r),
                        onTap: () async {
                          await context.setLocale(Locale(language.code));
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(DS.screenPadding.w),
                          decoration: DS.cardDecoration().copyWith(
                            border: Border.all(
                              color: isSelected ? DS.success : DS.borderLight,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(language.nativeName,
                                        style: DS.ts(15, FontWeight.w600, DS.textPrimary)),
                                    SizedBox(height: 2.h),
                                    Text(language.name,
                                        style: DS.ts(12, FontWeight.w400, DS.textSecondary)),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle_rounded,
                                    color: DS.success, size: 24.r),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}