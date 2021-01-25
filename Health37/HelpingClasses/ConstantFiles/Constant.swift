//
//  Constant.swift
//  Health37
//
//  Created by Deepak iOS on 22/02/18.
//  Copyright © 2018 Nine Hertz India. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
}

//MARK:-
//MARK:- BASE URL

//let Base_DOMAIN = "http://health37.com/"
let Base_DOMAIN = "https://dev.softprodigyphp.in/Health37/"
//let Base_DOMAIN = "http://15.185.132.50/"
//let Base_URL = "http://health37.com/services.php?serviceName="
let Base_URL = "https://dev.softprodigyphp.in/Health37/services.php?serviceName="
//let Base_URL = "http://15.185.132.50/services.php?serviceName="
//let Base_URL = "http://192.168.0.25/health-app/services.php?serviceName="


//MARK:- IMAGE URL


//MARK:- Max Limit for textfield

let kCouponCodeLength = 7
let kEmailLength = 50
let kFullNameLength = 30
let kPhoneLength = 16
let kPasswordLength = 20
let kNameLength = 20
let kOTPLength = 4
let kMobileNumerLenghtMin  = 8
let kPasswordLengthMin = 6

//MARK:- Userdefaults Keys


//MARK:- GoogleMapProvideKeys
let kGMSServiceApiKey = "AIzaSyCeGQ9WtTxI9i0SlESRkpqXj0WqPaGzwZY"//"AIzaSyA8yFGctMOQ-mo6GdXtKZNHhNr5acHjnEM"

///All URL Keys
let kMethodCheckUser = "checkUser"
let kMethodSignUp = "signup"
let kMethodLogout = "logout"
let kMethodChangePassword = "changePassword"
let kMethodLoginUser = "signin"
let kMethodForgotPass = "forgotPassword"
let kMethodGetCategory = "allSignupCategoires"//"allCategoires"
let kMethodGetCategoryHome = "allCategoires"
let kMethodAddDevices = "addDevices"
let kMethodNotificationCount = "lastSeen"
let kMethodAddNotification = "addSeen"
let kMethodPostHide = "hidePost"
let kMethodGetChildCategory = "childCategories"
let kMethodGetLocation = "location"
let kMethodCheckSocialUser = "checkSocialUser"
let kChangeLanguage = "changeLanguage"
let kMethodUpdateProfile = "editProfile"
let kMethodUpdateContact = "contactAdmin"
let kMethodAddFriend = "addFriend"
let kMethodRemoveFriend = "removeFriend"
let kMethodGroupPOST = "addGroupPost"
let kMethodAllUsersList = "allUser"
let kMethodSearchFriendList = "searchUser"
let kMethodSearchGroupList = "searchGroup"
let kMethodSearchAllUsers = "searchAll"
let kMethodGetProfile = "userProfile"
let kMethodAllPost = "getUserPosts"
var kMethodAddPost = "addPost"
let kMethodLikeUnlike = "likeUnlike"
let kMethodLikeUnlikeComment = "likeUnlikeComment"
let kMethodEnableAppointment = "enableAppointment"
let kMethodManageDiscountCoupon = "manageDiscountCoupon"
let kMethodGetCoupon = "getCoupon"
let kMethodGetCouponLocation = "getLocationOnCoupon"
let kMethodSetTimeSlot = "setTimeSlot"
let kMethodGetTimeSlot = "getTimeSlot"
let kMethodBookSlot = "setAppointment"
let kMethodCancelSlot = "cancelAppointment"
let kMethodGetAppointment = "getAppointment"
let kMethodEditBookSlot = "editAppointment"
let kMethodGetBookedSlot = "getSlotsOnDate"
let kMethodAddUser = "addDoctor"
let kMethodGetDoctorsList = "getDoctorsList"
let kMethodPayment = "payment"
let kMethodDeleteDoctor = "deleteDoctor"
let kMethodUpdateUser = "updateDoctor"
let kMethodAppointmentDetail = "getNotificationAppointment"
let kMethodCancelSubsciption = "cancelSubscription"
let kMethodSubsciptionPlans = "subcriptionPlanPrices"
let kMethodBookOfflineSlot = "bookOfflineAppointment"
let kMethodCancelOfflineSlot = "cancelOfflineBooking"



//allSignupCategories
let kMethodSinglePost = "singlePosts"
let kMethodAddComments = "addComments"
let kMethodReplyAddComments = "addCommentReply"
let kMethodPostComments = "postComments"
let kMethodMyLikePost = "myLikedPosts"
let kMethodHomeAllPost = "userConnectionPosts"
let kMethodFollowerFollowing = "userConnectionList"
let kMethodDeletePost = "removePost"
let kMethodAddReport = "addReport"
let kMethodShareTimeL = "sharePostTimeline"
let kMethodChatFriendList = "allConversation"
let kMethodNotificationsList = "allNotifications"
let kMethodGetRatingList = "getUserRating"
let kMethodAddRating = "addUserRating"
let kMethodChatFriendDetails = "getConversation"
let kMethodMessageSend = "addMessages"
let kMethodFollowUnfollow = "followUser"
let kMethodGroupOtherProfile = "singleGroup"
let kMethodAllGroups = "allGroups"
let kMethodJoinGroups = "joinGroup"
let kMethodLeaveGroups = "leaveGroup"

///AllOther Keys
let kLoginCheck = "isLogin"
let kDeviceToken = "token"
let kDeviceType = "device_type"
let kCurrentUser = "currentUser"

//MARK:- NSNotification
let kUpdateUserProfile = "UpdateUserProfile"

//MARK:- Server Keys
let kFirstName = "first_name"
let kLastName = "last_name"
let kSocialId        = "social_id"
let kSocialType      = "social_type"
let kDeviceName  = "IOS"

let kUserSavedDetails = "user_data"


let kUserID = "user_id"
let kFullName = "full_name"
let kCityID = "city_id"
let kCatName = "cat_name"
let kCountrycode = "country_code"
let kResend = "resend"
let kCountryname = "country_name"
let kCreateat = "created_at"
let kEmail = "email"
let kCatID = "cat_id"
let kParentID = "parent_id"
let kUserCat = "user_cat"
let kMasterCatID = "master_cat_id"

let kFriendID = "friend_id"
let kPageNo = "page"
let kKeyWord = "keyword"

let kPin = "pin"
let kEmailGet = "user_email"
let kCurrentPassword = "current"
let kNewPassword = "newpass"
let kPassword = "password"
let kDefaultLanguage = "default_language"


let kLatitude            = "user_lat"
let kLongitude            = "user_lon"
let kSecurityToken      = "security_token"

let kName = "name"
let kPhoneNumber = "phone_number"
let kPhoneCode = "phone_code"

let kProfilePic = "avatar"

let kUsername = "user_name"

let kUserBrief = "user_brief"


let kStatus = "status"
let kLastLogin = "user_last_login"
let kCreatedAt = "created_at"
let kUpdatedAt = "updated_at"
let kPostImage = "post_image"

let kPostData = "post_data"
let kData = "data"


//MARK:-
//MARK:- Signup Page error message
let kOTPSmsVerify = "The SMS verification code is invalid."
let kPhoneVerification = "Verification failed, please check your phone number"

let kEnterDescription = "Enter some description or query first."


let kInternetError = "Please check internet connection"
let kInternetErrorMessage = "Make sure your device is connected to the internet."

let kEnterNameError = "Please enter the name."
let kEnterUsernameError = "Please enter the user name."
let kEnterFullnameError = "Please enter full name."


let kEnterEmailError = "Please enter the email address."

let kEnterRatingError = "Please enter your reviews."

let kEnterVaildEmailError = "Please enter the valid email address."

let kEnterSearchTextError = "Please enter search text."

let kSelectCountryCodeError = "Please select country code."
let kMobileNumError = "Please enter the phone number."
let kMobileNumLengthError = "Phone Number must be of minimum 8 characters."
let kEnterPasswordError = "Please enter the password."
let kEnterConfirmPasswordError = "Please enter the confirm password."
let kPasswordsMatchingError = "Password and Confirm Password should be match."

let kPasswordAcceptableLengthError = "Password must be of minimum 6 characters."

let kEnterOTPNumberError = "Please enter the otp."

let kEnterAddCommentError = "Please enter the add comments."

let kEnterPostError = "Please write something or atleast select a photo."

let kEnterOTPLengthError = "OTP must be of minimum 6 characters."

let kEnterNewPassError = "Please enter new password."


let kTwitterConsumerKey             = "u5V4VyTz28lRK4vGdC2cC6Qgs"
let kTwitterConsumerSecret          = "mCYJpgJQd1gX5RnUa1f739v5T1qLyPgrEEBe8uaLN7VFwDJrLK"


//let  kGoogleClientID = "574624509150-q5m5cft5bmlumbjr4b6f0sjt1meuettk.apps.googleusercontent.com"
let  kGoogleClientID = "527528127919-t5ukduci11r85tif7i13i33vl2titb94.apps.googleusercontent.com"

//// GoogleConsole ID and Pass =  rpc7979@gmail.com   Pass == shreeshyam

//Google-Login> rpc7979-->
//Twitter&ndash;&gt;= testsomerge101@gmail.com-->     Pass == shreeshyam
//facebook->anveshanb pass testaccount1



//Health37 Client ID:
//
//Email : drsalbum@outlook.sa     [use Id for Login Itunes]
//Password : Zayed2020$
