import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum Benefits { discount, cash, results, voucher }

enum BenefitInputType { singleField, doubleFields }

final benefitsType = {
  Benefits.discount.name: BenefitType.unified,
  Benefits.cash.name: BenefitType.cash,
  Benefits.results.name: BenefitType.unified,
  Benefits.voucher.name: BenefitType.unique,
};

final benefitsInputType = {
  Benefits.discount.name: BenefitInputType.doubleFields,
  Benefits.cash.name: BenefitInputType.singleField,
  Benefits.results.name: BenefitInputType.singleField,
  Benefits.voucher.name: BenefitInputType.doubleFields,
};

const Icon voucherIcon = Icon(
  Icons.card_giftcard,
  size: iconSize36,
);

const Icon discountIcon = Icon(
  Icons.local_offer,
  size: iconSize36,
);

const Icon cashIcon = Icon(
  Icons.monetization_on,
  size: iconSize36,
);
const Icon resultIcon = Icon(
  Icons.bar_chart,
  size: iconSize36,
);

const Icon voucherIconD = Icon(
  Icons.card_giftcard,
  size: iconSize16,
  color: iconsColor,
);

const Icon discountIconD = Icon(
  Icons.local_offer,
  size: iconSize16,
  color: iconsColor,
);

const Icon cashIconD = Icon(
  Icons.monetization_on,
  size: iconSize20,
  color: iconsColor,
);
const Icon resultIconD = Icon(
  Icons.bar_chart,
  size: iconSize16,
  color: iconsColor,
);

const Icon voucherIconSmall = Icon(
  Icons.card_giftcard,
  size: iconSize16,
);

const Icon discountIconSmall = Icon(
  Icons.local_offer,
  size: iconSize16,
);

const Icon cashIconSmall = Icon(
  Icons.monetization_on,
  size: iconSize16,
);
const Icon resultIconSmall = Icon(
  Icons.bar_chart,
  size: iconSize16,
);

List<String> benefitsMenue = [for (final b in Benefits.values) b.name];

final Map<String, Icon> benefitsIconsLarge = {
  Benefits.discount.name: discountIcon,
  Benefits.cash.name: cashIcon,
  Benefits.results.name: resultIcon,
  Benefits.voucher.name: voucherIcon,
};

final Map<String, Icon> kBenefitsIconsSmall = {
  Benefits.discount.name: discountIconSmall,
  Benefits.cash.name: cashIconSmall,
  Benefits.results.name: resultIconSmall,
  Benefits.voucher.name: voucherIconSmall,
};

final Map<String, Icon> benefitsIconsMenueDark = {
  Benefits.discount.name: discountIconD,
  Benefits.cash.name: cashIconD,
  Benefits.results.name: resultIconD,
  Benefits.voucher.name: voucherIconD,
};

final Map<String, String> benefitsHints = {
  Benefits.discount.name: "10%",
  Benefits.cash.name: "100SAR",
  Benefits.results.name: "Results File PDF",
  Benefits.voucher.name: "100SAR",
};

final Map<String, String> benefitsLabels = {
  Benefits.discount.name: "Percentage",
  Benefits.cash.name: "Value",
  Benefits.results.name: "Results",
  Benefits.voucher.name: "Value",
};

final Map<String, String> benefitsSuffix = {
  Benefits.discount.name: "%",
  Benefits.cash.name: " SAR",
  Benefits.results.name: "",
  Benefits.voucher.name: " SAR",
};
