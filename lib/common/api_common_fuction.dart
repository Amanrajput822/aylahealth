
class Endpoints {
  /// development (staging) base url for developer
  static const baseURL = "https://staging.aylahealth.app/api/auth/";

  /// production base url for live
 // static const baseURL = "https://aylahealth.app/api/auth/";


  static const Login = 'login';
  static const Signup = 'signup';
  static const socialLogin = 'socialLogin';
  static const logout = 'logout';
  static const changePassword = 'changePassword';


  static const questionOptionList = 'questionOptionList';
  static const ingredientNameList = 'ingredientNameList';
  static const addOrUpdateCustomerAnswer = 'addOrUpdateCustomerAnswer';
  static const customerNutritionArea = 'customerNutritionArea';
  static const genderList = 'genderList';

  static const customerDetails = 'customerDetails';
  static const updateCustomer = 'updateCustomer';

  static const customerFoodSettingHeadingList = 'customerFoodSettingHeadingList';
  static const customerFoodSettingData = 'customerFoodSettingData';

  static const recipeList = 'recipeList';
  static const recipeDetails = 'recipeDetails';
  static const updateMealPlanRecipeServes = 'updateMealPlanRecipeServes';
  static const markRecipeFavorite = 'markRecipeFavorite';
  static const unmarkRecipeFromFavorite = 'unmarkRecipeFromFavorite';
  static const allRecipeFiltersList = 'allRecipeFiltersList';
  static const recipeCategoryList = 'recipeCategoryList';

  static const addOrUpdateMealPlan = 'addOrUpdateMealPlan';
  static const customerMealPlanData = 'customerMealPlanData';
  static const customerFiveMonthMealPlanData = 'customerFiveMonthMealPlanData';
  static const mealTimeList = 'mealTimeList';
  static const customerMealOfDay = 'customerMealOfDay';


  static const sendCustomerContactEmail = 'sendCustomerContactEmail';
  static const faqList = 'faqList';

  static const customerShoppingList = 'customerShoppingList';
  static const createShoppingList = 'createShoppingList';
  static const updateShoppingItemStatus = 'updateShoppingItemStatus';

  static const forgotPassword = 'forgotPassword';
  static const verifyForgotPasswordCode = 'verifyForgotPasswordCode';
  static const resetPassword = 'resetPassword';

  static const recipeCollectionList = 'recipeCollectionList';

  static const customerNotificationSetting = 'customerNotificationSetting';
  static const updateCustomerNotificationSetting = 'updateCustomerNotificationSetting';


  static const moduleLibrary = 'moduleLibrary';
  static const modulePagesContentList = 'modulePagesContentList';
  static const updateCustomerModuleViewStatus = 'updateCustomerModuleViewStatus';
  static const customerModuleViewStatus = 'customerModuleViewStatus';
  static const searchModule = 'searchModule';
  static const moduleDetailsForApp = 'moduleDetailsForApp';
  static const continueLearningModuleList = 'continueLearningModuleList';
  static const freeModuleList = 'freeModuleList';

  static const deleteCustomerApp = 'deleteCustomerApp';

  // static const addCustomerSubscriptionDetails = 'addCustomerSubscriptionDetails';
  static const subscribeApp = 'subscribeApp';
  static const customerSubscriptionDetails = 'customerSubscriptionDetails';
  static const checkSubscription = 'checkSubscription';


}