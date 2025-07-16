import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/expenses/page_data/page_data.dart';
import 'package:users_repository/users_repository.dart';

class CreateExpensePage extends StatefulWidget {
  const CreateExpensePage({
    required this.houseId,
    required this.memberId,
    super.key,
  });
  final String houseId;
  final String memberId;
  @override
  State<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final totalAmountController = TextEditingController();
  final splitAmountController = TextEditingController();
  String title = '';
  String description = '';
  String category = '';
  List<Map<String, dynamic>> splits = [];
  double? totalAmount;
  double splitAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    totalAmountController.dispose();
    splitAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageView(
      title: 'Create Expense',
      body: BlocProvider(
        create: (context) => ExpensesCubit(
          expensesRepository: context.read<ExpensesRepository>(),
        ),
        child: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpacer(multiple: 2),
                    customTextFormField(
                        context: context,
                        label: 'Expense Name',
                        controller: titleController,
                        onBackground: true,
                        onChanged: (value) => setState(() {
                              title = value.trim();
                            })),
                    const VerticalSpacer(),
                    customTextFormField(
                        context: context,
                        label: 'Expense Description',
                        controller: descriptionController,
                        onBackground: true,
                        onChanged: (value) => setState(() {
                              description = value.trim();
                            })),
                    const VerticalSpacer(),
                    customTextFormField(
                      context: context,
                      label: 'Total Due',
                      controller: totalAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (amount) => setState(() {
                        totalAmount = double.tryParse(amount.trim());
                      }),
                      onBackground: true,
                    ),
                    const VerticalSpacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: category.isEmpty
                              ? 'Select Category'
                              : 'Category: ${category.toTitleCase}',
                          style: AppTextStyles.primary,
                        ),
                        DropDown(
                          dropDownItems:
                              List.generate(categoryData.length, (index) {
                            final categoryAtIndex =
                                categoryData.keys.toList()[index];
                            return DropDownItem(
                              icon: categoryData[categoryAtIndex] ??
                                  AppIcons.money,
                              text: categoryAtIndex,
                              onSelect: () async {
                                setState(() {
                                  category = categoryAtIndex;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    if (totalAmount != null && totalAmount != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: 'Add Split',
                            style: AppTextStyles.primary,
                          ),
                          DropDown(
                            dropDownItems: List.generate(3, (index) {
                              return DropDownItem(
                                icon: AppIcons.user,
                                text: 'User $index',
                                onSelect: () async {
                                  try {
                                    final newSplit =
                                        await _expenseSplitFormPopup(
                                      context: context,
                                      memberId: 'user-231412$index',
                                    );
                                    setState(() {
                                      splitAmount = 0.0;
                                      splitAmountController.clear();
                                    });
                                    if (newSplit == null) return;
                                    setState(() {
                                      splits.add(newSplit);
                                    });
                                  } catch (e) {
                                    debugPrint(
                                        'Failure creating expense split ${e.toString()}');
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    const VerticalSpacer(),
                    if (splits.isEmpty)
                      const CustomText(
                        text: 'No splits have been made yet',
                        style: AppTextStyles.secondary,
                      )
                    else
                      Column(
                        children: List.generate(
                          splits.length,
                          (index) => Stack(
                            key: ObjectKey(
                              splits[index][ExpenseSplit.memberIdConverter],
                            ),
                            children: [
                              ExpenseSplitsCard(
                                split: ExpenseSplit.fromJson(splits[index]),
                                paid: false,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  // Use GestureDetector for better tap control
                                  onTap: () => setState(() {
                                    splits.removeAt(index);
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: context.theme.errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: defaultIconStyle(
                                      context,
                                      AppIcons.cancel,
                                      context.theme.backgroundColor,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const VerticalSpacer(),
                    if (title.isNotEmpty &&
                        totalAmount != null &&
                        totalAmount != 0.0 &&
                        category.isNotEmpty)
                      CustomButton(
                        color: context.theme.accentColor,
                        text: 'Submit Expense',
                        onTap: () async {
                          titleController.clear();
                          descriptionController.clear();
                          totalAmountController.clear();
                          splitAmountController.clear();
                          context.read<ExpensesRepository>().createExpenses(
                            data: {
                              Expenses.houseIdConverter: widget.houseId,
                              Expenses.houseMemberIdConverter: widget.memberId,
                              Expenses.totalAmountConverter: totalAmount,
                              Expenses.titleConverter: title,
                              Expenses.descriptionConverter: description,
                              Expenses.categoryConverter: category,
                              Expenses.isSettledConverter: false,
                              Expenses.splitsConverter: {"splits": splits},
                            },
                            token:
                                context.read<UsersRepository>().idToken ?? '',
                          );
                          setState(() {
                            splits.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _expenseSplitFormPopup({
    required BuildContext context,
    required String memberId,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: CustomText(
          text: 'Add a Split For Member: $memberId',
          style: AppTextStyles.primary,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextFormField(
                context: context,
                label: 'Total Due',
                controller: splitAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onBackground: true,
                onChanged: (amount) => setState(() {
                  splitAmount =
                      double.tryParse(amount.trim()) ?? (totalAmount! / 2.0);
                }),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const HorizontalSpacer(),
              Expanded(
                child: CustomButton(
                  text: 'Save',
                  onTap: () {
                    Navigator.of(context).pop({
                      ExpenseSplit.amountOwedConverter: splitAmount,
                      ExpenseSplit.memberIdConverter: memberId,
                      ExpenseSplit.paidOnConverter: null,
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
