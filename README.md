# eTouristAgency

## Kredencijali

### Desktop verzija:

Korisnicko ime: desktop

Lozinka: test

### Mobilna verzija:

Korisnicko ime: mobile

Lozinka: test


## Desktop app

### Login screen

<img src="/Screenshots/desktop-login.png">

The Login screen allows users to access the system by entering their username and password.
If a user has forgotten their password, a clickable “Forgot your password?” link is available, providing the option to reset it.

### Forgot password screen

<img src="/Screenshots/desktop-forgot-password.png">

The Forgot Password screen requires the user to enter their email address.
After submitting the form by clicking the “Send Request” button, a verification code is sent to the user’s email.

The user must then enter this code into a dialog/modal to proceed with the password reset process.

<img src="/Screenshots/desktop-forgot-password-dialog.png">

### Reset password screen

<img src="/Screenshots/desktop-reset-password.png">

The Reset Password screen allows users to set a new password after successfully verifying their email with the verification code.

### Offers Section

<img src="/Screenshots/desktop-offers.png">

The Offers section contains a table with the most relevant information about all available offers.
Each row includes the following action buttons:
Edit – redirects the user to a form for editing the selected offer.
Reservations – redirects the user to a list of all reservations associated with that offer.
Reviews – becomes visible only on the return date from the destination and redirects the user to a list of all submitted reviews.

This section also provides several filters for narrowing down the list of offers:
- Offer Number
- Country
- Offer Status
- Date Range (between departure and return dates)

Additionally, the screen includes a Add button that opens a form for creating a new offer.
Pagination is implemented as well, displaying 15 records per page.

### Add/Update Offer Form

<img src="/Screenshots/desktop-add-update-offer-form-1.png">
<img src="/Screenshots/desktop-add-update-offer-form-2.png">

The Add / Update Offer form allows users to manage all essential details of a travel offer. It includes:
Main Image Upload – upload the primary image for the offer.
Document Upload – upload a document containing the rules or travel guidelines.
Relevant Fields – input fields for all other key details of the offer.

The form also contains two subsections:
Discounts – includes accordion elements where users can add one First Minute and one Last Minute discount.
Rooms – includes accordion elements for adding multiple room types. Each accordion represents a single room type with all relevant details and the number of available rooms for that type.

All of these components are available both in the Add and Edit forms, with certain restrictions applied once the offer is active.
Draft – when initially created, an offer can be saved as a draft.
Activation – after activation, the offer becomes visible to clients and available for reservations.
Deactivation – an active offer can be deactivated, making it unavailable for further reservations.

Notes on Editing Active Offers
- Once an offer is activated, rooms can no longer be edited.
- Discounts can only be edited or deleted if they have not yet started. Discounts that have already started or expired cannot be changed.

Notifications on Offer Activation
- When an offer is activated, a content-based recommendation algorithm selects 100 users whose interests best match the offer.
- These users automatically receive both push notifications and email notifications informing them about the new offer.

### Reservations section

<img src="/Screenshots/desktop-reservations.png">

The Reservations section is accessed via the Reservations button within a specific offer. It contains a table with all relevant information about the reservations associated with that offer.
Each row in the table includes an Details button that redirects the user to a reservation details screen. On this screen, certain fields are editable in the desktop application, allowing changes to be made directly to the reservation.

This section also provides filtering options:
- Reservation Number
- Reservation Status

Additionally, there is a Download Passenger List button that generates a Word document containing all passengers for the selected offer.
Only passengers from reservations with the status Paid are included in the document.

### Reservation details section

<img src="/Screenshots/desktop-reservation-details.png">

The Reservation Details screen provides an overview of a specific reservation. It includes:
Offer Information – key details related to the offer linked to the reservation.
Passengers Subsection – a list of all passengers included in the reservation, along with their details.
Payment Proofs Subsection – a collection of all files uploaded by the client as proof of payment.

In addition, certain fields are editable in the desktop application for admin users:
- Paid Amount
- Reservation Status

These fields can be updated until the departure date. Any modification made by an admin automatically triggers both an email and a push notification to the client.

The screen also includes a View Review button, which opens a modal displaying the details of the client’s review. This button is only visible if the client has submitted a review.

<img src="/Screenshots/desktop-reservation-details-review-dialog.png">

### Offer reviews section

<img src="/Screenshots/offer-reviews.png">

The Offer Reviews section displays a table containing all relevant information about reviews for a specific offer.

Each row includes a Details button that opens a dialog/modal showing:
- A visual representation of ratings (stars).
- The comment left by the client after completing the trip.

<img src="/Screenshots/offer-reviews-dialog.png">

### Users section

<img src="/Screenshots/desktop-users.png">

The Users section contains a table listing all users in the system, including both administrators and clients. The table displays all relevant information about each user.
Each row includes an Edit button that opens a dialog for updating the selected user’s information.

This section also provides filtering options:
- First Name and Last Name
- Username
- Email
- User Role (Admin or Client)

Additional features:
Pagination – 15 records are displayed per page.
Add button – opens a modal for creating a new user, either an admin or a client.

Clicking the Edit button on a user with the Client role opens a dialog/modal where the following actions are available:
- Verify Email – allows verification of the client’s email address (if not already verified).
- Reset Password – generates a new password for the client and automatically sends it to their registered email address.

<img src="/Screenshots/desktop-edit-client-dialog.png">

Clicking the Edit button on a user with the Admin role opens a dialog/modal where the following actions are available:
- Edit User Information – update selected details of the admin user.
- Delete Account – permanently remove the user account from the system.

<img src="/Screenshots/desktop-edit-admin-dialog.png">

### Entity Codes section

<img src="/Screenshots/desktop-entity-codes.png">

Clicking the Entity Codes button in the navigation bar opens a dropdown with a list of available codebooks.
Selecting a codebook opens a table displaying all values for the chosen codebook.
Each row contains an Edit button, which opens a dialog/modal for updating the selected codebook value.
The screen also includes an Add button that opens a dialog/modal for creating a new entry in the codebook.

### Hotels section

<img src="/Screenshots/desktop-hotels.png">

The Hotels section contains a table listing all hotels in the system.

Features include:
- Pagination – 15 records are displayed per page.
- Filters – hotels can be filtered by: Hotel Name, City
- Edit button – redirects the user to a form for editing the selected hotel.
- Add button – redirects the user to a form for creating a new hotel.

### Add/Update hotel form

<img src="/Screenshots/desktop-add-update-hotel-form.png">

The Add/Update Hotel form allows users to create or modify hotel information.

Features include:
- Hotel Information – input and edit all relevant details about the hotel.
- Hotel Images – upload, edit, and delete images associated with the hotel.

### Account details

<img src="/Screenshots/desktop-account.png">

The Account Details section displays the information of the currently logged-in user.
It also provides the option to update and edit personal details.