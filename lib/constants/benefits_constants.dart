// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum Benefits { Discount, Cash, Results, Voucher }

enum BenefitInputType { TextField, XinY }

final benefitsType = {
  Benefits.Discount.name: BenefitType.unified,
  Benefits.Cash.name: BenefitType.cash,
  Benefits.Results.name: BenefitType.unified,
  Benefits.Voucher.name: BenefitType.unique,
};

final benefitsInputType = {
  Benefits.Discount.name: BenefitInputType.XinY,
  Benefits.Cash.name: BenefitInputType.TextField,
  Benefits.Results.name: BenefitInputType.TextField,
  Benefits.Voucher.name: BenefitInputType.XinY,
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
  Benefits.Discount.name: discountIcon,
  Benefits.Cash.name: cashIcon,
  Benefits.Results.name: resultIcon,
  Benefits.Voucher.name: voucherIcon,
};

final Map<String, Icon> kBenefitsIconsSmall = {
  Benefits.Discount.name: discountIconSmall,
  Benefits.Cash.name: cashIconSmall,
  Benefits.Results.name: resultIconSmall,
  Benefits.Voucher.name: voucherIconSmall,
};

final Map<String, Icon> benefitsIconsMenueDark = {
  Benefits.Discount.name: discountIconD,
  Benefits.Cash.name: cashIconD,
  Benefits.Results.name: resultIconD,
  Benefits.Voucher.name: voucherIconD,
};

final Map<String, String> benefitsHints = {
  Benefits.Discount.name: "10%",
  Benefits.Cash.name: "100SAR",
  Benefits.Results.name: "Results File PDF",
  Benefits.Voucher.name: "100SAR",
};

final Map<String, String> benefitsLabels = {
  Benefits.Discount.name: "Percentage",
  Benefits.Cash.name: "Value",
  Benefits.Results.name: "Results",
  Benefits.Voucher.name: "Value",
};

final Map<String, String> benefitsSuffix = {
  Benefits.Discount.name: "%",
  Benefits.Cash.name: " SAR",
  Benefits.Results.name: "",
  Benefits.Voucher.name: " SAR",
};
