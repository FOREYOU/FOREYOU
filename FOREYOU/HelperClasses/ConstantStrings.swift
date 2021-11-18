//
//  ConstantStrings.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ConstantStrings: NSObject {
    
    
    
       // static let bossBackgroundColor = UIColor(hexString: "02bf67")
    

    static let SELECTED_CHECK_BOX = "check_box"
    static let UNSELECTED_CHECK_BOX = "uncheck_box"
    
//    static let RUPEES_SYMBOL = "₹"
  //  static let RUPEES_SYMBOL = appCurrencySymbol
    
    static let VEG_IMAGE = ""
    static let NON_VEG_IMAGE = "food_type"
    
    static let VEG_FOOD_TYPE = "1"
    static let NON_VEG_FOOD_TYPE = "2"
    
    static let ITEM_ADDED_TO_CART = "1"
    static let ITEM_NOT_ADDED_TO_CART = "0"
    
    static let SELECTED_VALUE = "1"
    static let UNSELECTED_VALUE = "0"
    
    static let FOOD_TAX_7 = "7"
    static let FOOD_TAX_19 = "19"
    
    static let OK_STRING = "Ok"
    static let CANCEL_STRING = "Cancel"
    static let WELCOME_GUEST_STRING = "Welcome Guest"
    
    static let SELECTED_RADIO_BUTTON = "selected_radio"
    static let UNSELECTED_RADIO_BUTTON = "unselected_radio"
    static let CATGORY_PLACEHOLDER = "category_placeholder"
    static let SELECTED_ADDRESS_IMAGE = "selected_address"
    static let UNSELECTED_ADDRESS_IMAGE = "un_selected_address"
    
    static let FALSE_STRING = "No"
    static let TRUE_STRING = "Yes"
    
    static let DEVICE_VERSION = "iOS"
    
//    Food Status
    static let ORDER_RECIEVED_STATUS = 1
    static let ORDER_PREPARED_STATUS = 2
    static let ORDER_OUT_OF_DELIVERY_STATUS = 3
    static let ORDER_DELIVERED_STATUS = 4
    
//    Order Type Value
    static let ORDER_TYPE_VALUE = "orderType"
    static let POSTAL_CODE_STRING = "postalCodeString"
    static let ORDER_TYPE_DELIVERY = 1
    static let ORDER_TYPE_PICKUP = 2
    static let ORDER_TYPE_DINING = 3
    
    static let ORDER_TYPE_DELIVERY_STRING = "Delivery"
    static let ORDER_TYPE_PICKUP_STRING = "Pickup"
    static let ORDER_TYPE_DINING_STRING = "EAT-IN"
    static let ORDER_STATUS_CANCELLED = "Cancelled"
    static let ITEM_EXTRA_TOPPING_SELECTION_TYPE = "Checkbox"
    
//    Constant for User Defaults
    static let IS_GUEST_USER = "isGuestUser"
    static let IS_USER_LOGGED_IN = "isUserLoggedIn"
    
//    Userdefaults Store data string
    static let HOME_SLIDER_IMAGE = "homeSliderImage"
    static let CATEGORY_LIST = "categoryList"
    static let RESTAURANT_INFORMATION = "restaurantInformation"
    static let LOCATION_DATA = "locationData"
    static let RECOMMENDED_DATA = "recommendedData"
    static let RESTAURANT_INFO = "restaurantInfo"
    static let USER_LOCATION_INFO = "userLocationInfo"
    static let CART_ITEM_LIST = "cartItemList"
    static let USER_DETAILS = "userDetails"
    static let COUNTRY_CODE = "countryCode"
    static let POSTAL_CODE_INFO = "postalCodeInfo"
    static let LOYALTY_POINTS = "loyaltyPoints"
    static let IS_COUPON_APPLIED = "isCouponApplied"
    static let IS_LOYALTY_POINTS_REDEEMED = "isLoyaltyPointsRedeemed"
    static let APPLIED_COUPON_CODE = "appliedCouponCode"
    static let APPLIED_COUPON_AMOUNT = "appliedCouponAmount"
    static let APPLIED_LOYALTY_POINTS_AMOUNT = "appliedLoyalityPointsAmount"
    static let APPLIED_LOYALTY_POINTS = "appliedLoyalityPoints"
    static let STRIPE_PAYMENT_PUBLISH_KEY = "stripePaymentPublishKey"
    static let REFERRAL_STRING = "referralString"
    static let REFERRAL_CODE = "referralCode"
    static let REFERRAL_CODE_MESSAGE = "referralCodeMessage"
    static let REFERRAL_CODE_SHARE_FRIEND = "referralCodeShareFriend"
    static let SELECTED_TABLE_NUMBER = "selectedTableNumber"
    static let PAYPAL_CLIENT_KEY = "paypalClientKey"
    static let PAYPAL_SECRET_KEY = "paypalSecretKey"
    
//    Message for display
    static let ALERT = "ALERT"
    static let INVALID = "Invalid"
    static let NETORK_ISSUE = "Network Issue"
    static let ITEMS = "Item(s)"
    
    static let DATA_IS_NOT_AVAILABLE = "Data isn't available here."
    static let FIRST_NAME_FIELD_IS_REQUIRED = "First name field is required."
    static let USERNAME_FIELD_IS_REQUIRED = "Username field is required."
    static let NAME_FIELD_IS_REQUIRED = "Name field is required."
    static let PASSWORD_FIELD_IS_REQUIRED = "Password field is required."
    static let CONFIRM_PASSWORD_FIELD_IS_REQUIRED = "Confirm password field is required."
    static let PASSWORD_AND_CONFIRM_PASSWORD_DIDNOT_MATCH = "Password and confirm password didn't match."
    
    static let PLEASE_ENTER_OTP = "Please enter OTP."
    
    static let PLEASE_SELECT_SERVICE_DATE = "Please select service date."
    static let PLEASE_SELECT_SERVICE_TIME = "Please select service time."
    static let PLEASE_SELECT_SERVICE_TYPE = "Please select service Type."
    static let PLEASE_SELECT_PAYMENT_TYPE = "Please select payment Type."
    
    
    static let pleaseCheckYourInternetConnection = "Unable to connect to internet. Please check your internet connection."
    
    static let MOBILE_NO_FIELD_IS_REQUIRED = "Mobile no field is required."
    static let MESSAGE_FIELD_IS_REQUIRED = "Message field is required."
    static let EMAIL_FIELD_IS_REQUIRED = "Email field is required."
    static let EMAIL_OR_PHONE_FIELD_IS_REQUIRED = "Email or phone field is required."
    static let PLEASE_ENTER_VALID_MOBILE = "Please enter valid mobile no."
    static let PLEASE_ENTER_VALID_EMAIL = "Please enter valid email ID."
    static let ADDRESS_FIELD_IS_REQUIRED = "Address field is requied."
    static let DEVICE_DOES_NOT_SUPPORT_CAMERA = "Camera is not available on this device."
    static let COULD_NOT_CONNECT_TO_SERVER = "Could not connect to server please try again."
    static let FIRSTLY_PLEASE_ADD_INTO_CART = "Please firstly add into cart."
    static let ITEM_HAS_BEEN_ADDED_INTO_CART = "Item has been added into cart."
    static let SUCCESSFULLY_LOGGED_IN = "You are successfully logged in."
    static let ADDRESS_TITLE_FIELD_IS_REQUIRED = "Address title field is required."
    static let POSTAL_CODE_FIELD_IS_REQUIRED = "Postal code field is required."
    static let CITY_NAME_FIELD_IS_REQUIRED = "City name field is required."
    static let PLEASE_ENTER_VALID_POSTAL_CODE = "Please enter valid 6 digit postal code."
    static let PLEASE_SELECT_ORDER_TYPE = "Please select order type."
    static let APPLY_COUPON_IS_REQUIRED = "Apply coupon field is required."
    static let YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY = "Your coupon has been applied is successfully."
    static let PLEASE_SELECT_ADDRESS = "Please select address for delivery."
    static let PLEASE_SELECT_PAYMENT_MODE = "Please select payment mode."
    static let YOUR_CART_IS_EMPTY = "Cart is empty. Please add at least one item in your cart."
    static let NO_ORDER_YET = "No order yet."
    static let HOME_NUMBER_IS_REQUIRED = "House/Door/Flat number field is required."
    static let STREET_NAME_IS_REQUIRED = "Street name field is required."
    static let ENTER_VALID_POSTAL_CODE = "Please enter valid postal code."
    static let PLEASE_LOGIN_FIRSTLY = "Please login firstly."
    static let FLAT_NAME_IS_REQUIRED = "Flat name field is required."
    static let WRITE_REVIEW_IS_REQUIRED = "Write review field is required."
    static let RATING_REVIEW_COULD_NOT_SUBMITTED = "Your rating and review could not submitted. Plese try again later."
    static let OLD_PASSWORD_IS_REQUIRED = "Old Password field is required."
    static let NEW_PASSWORD_IS_REQUIRED = "New Password field is required."
    static let RE_TYPE_PASSWORD_IS_REQUIRED = "Re-Type Password field is required."
    static let BOTH_PASSWORD_SHOULD_BE_SAME = "New Password and Re-Type Password should be same."
    static let YOU_HAVE_ZERO_LOYALTY_POINTS = "You have 0 loyalty points. So you can not redeem it."
    static let ARE_YOU_SURE_YOU_WANT_TO_LOGOUT = "Are you sure you want logout?"
    static let PLEASE_CHOOSE_ONE_OPTION = "Please choose one option."
    
//    new for language
    static let YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = "You need to login first for book a table."
    static let NO_CORDINATES_AVAILABLE = "No cordinates available."
    static let NO_PICTURE_UPLOADED_YET = "No picture uploaded yet."
    static let NO_OFFER_AVAILABLE = "No offer available."
    static let LOYALTY_POINT_FIELD_IS_REQUIRED = "Loyalty point field is required."
    static let PLEASE_ENTER_MORE_THAN_POINTS = "Please enter more than 0 points."
    static let YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS = "You do not have enough loyalty points."
    static let YOUR_ORDER_COULD_NOT_PLACED = "Your order could not be placed. Please try again."
    static let PLEASE_SELECT_PAYMENT_METHOD = "Please select payment method."
    static let GO_TO_MENU = "Go to Menu"
    static let CONFIRM_DELIVERY_ADDRESS = "Confirm Delivery Address"
    static let PHONE_NUMBER = "Phone No."
    static let CONFIRM_AND_PAY = "Confirm & Pay"
    static let ITEM_HAS_BEEN_ADDED_IN_PAY_LATER_ORDER = "Item has been added in pay later order."
    static let PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING = "Please choose at least one topping."
}

//New Items
//Item has been added in pay later order.
//You have been choosed your $ free topping.
//Please choose at least onen topping.
//Choose Any $ Topping Free
//Pay Now

