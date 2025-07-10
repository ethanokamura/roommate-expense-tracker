import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/cards/expense_splits_card.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/category_data.dart';

class CreateExpensePage extends StatefulWidget {
  const CreateExpensePage({required this.memberId, super.key});
  final String memberId;
  @override
  State<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final totalAmountController = TextEditingController();
  String category = 'misc';
  List<ExpenseSplit> splits = [];
  double? totalAmount;

  @override
  void initState() {
    super.initState();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacer(multiple: 2),
                  customTextFormField(
                    context: context,
                    label: 'Expense Name',
                    controller: titleController,
                    onBackground: true,
                  ),
                  const VerticalSpacer(),
                  customTextFormField(
                    context: context,
                    label: 'Expense Description',
                    controller: descriptionController,
                    onBackground: true,
                  ),
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
                      const CustomText(
                        text: 'Select Category',
                        style: AppTextStyles.primary,
                      ),
                      DropDown(
                        dropDownItems:
                            List.generate(categoryData.length, (index) {
                          final categoryAtIndex =
                              categoryData.keys.toList()[index];
                          return DropDownItem(
                            icon:
                                categoryData[categoryAtIndex] ?? AppIcons.money,
                            text: categoryAtIndex,
                            onSelect: () async {},
                          );
                        }),
                      ),
                    ],
                  ),
                  DefaultContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: 'No Member Selected',
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
                                  onSelect: () async {},
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: 'Is Settled',
                              style: AppTextStyles.primary,
                            ),
                            DropDown(dropDownItems: [
                              DropDownItem(
                                icon: AppIcons.confirm,
                                text: 'True',
                                onSelect: () async {},
                              ),
                              DropDownItem(
                                icon: AppIcons.cancel,
                                text: 'False',
                                onSelect: () async {},
                              ),
                            ]),
                          ],
                        ),
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
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     const CustomText(
                        //       text: 'Split Amount',
                        //       style: AppTextStyles.primary,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  if (splits.isEmpty)
                    const CustomText(
                      text: 'No splits have been made yet',
                      style: AppTextStyles.secondary,
                    )
                  else
                    Column(
                        children: List.generate(
                      splits.length,
                      (index) => ExpenseSplitsCard(split: splits[index]),
                    )),
                  const VerticalSpacer(),
                  CustomButton(
                    text: 'Add Split',
                    icon: AppIcons.add,
                    onTap: totalAmount != null && totalAmount != 0
                        ? () async {
                            final split = await _expenseSplitFormPopup(
                              context: context,
                              totalAmount: totalAmount!,
                            );
                            if (split == null) return;

                            setState(() {
                              splits.add(split);
                            });
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<ExpenseSplit?> _expenseSplitFormPopup({
    required BuildContext context,
    required double totalAmount,
  }) async {
    return await showDialog<ExpenseSplit>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: const CustomText(
          text: 'Add a Split.',
          style: AppTextStyles.primary,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: defaultPadding * 2,
                  left: defaultPadding * 2,
                  right: defaultPadding * 2,
                  bottom: 60,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [DropDown(dropDownItems: [])],
                ),
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
                    Navigator.of(context).pop(
                      ExpenseSplit.fromJson(
                        {
                          ExpenseSplit.amountOwedConverter: 0.0,
                          ExpenseSplit.memeberIdConverter: "1234",
                          ExpenseSplit.paidOnConverter: null,
                        },
                      ),
                    );
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

class ExpenseSplitForm extends StatelessWidget {
  const ExpenseSplitForm({required this.split, super.key});
  final ExpenseSplit split;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
