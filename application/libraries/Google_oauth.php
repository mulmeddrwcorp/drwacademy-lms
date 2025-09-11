<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Google OAuth Helper for CodeIgniter
 * 
 * This helper provides functions to handle Google OAuth authentication
 */

class Google_oauth {
    
    private $client;
    private $CI;
    
    public function __construct() {
        $this->CI =& get_instance();
        
        // Load Google Client Library
        require_once APPPATH . '../vendor/autoload.php';
        
        $this->client = new Google_Client();
        $this->client->setClientId($this->CI->config->item('google_client_id'));
        $this->client->setClientSecret($this->CI->config->item('google_client_secret'));
        $this->client->setRedirectUri($this->CI->config->item('google_redirect_uri'));
        $this->client->addScope('email');
        $this->client->addScope('profile');
    }
    
    /**
     * Get Google OAuth login URL
     */
    public function get_login_url() {
        return $this->client->createAuthUrl();
    }
    
    /**
     * Handle OAuth callback and get user info
     */
    public function handle_callback($code) {
        try {
            // Exchange authorization code for access token
            $token = $this->client->fetchAccessTokenWithAuthCode($code);
            
            if (isset($token['error'])) {
                return false;
            }
            
            $this->client->setAccessToken($token);
            
            // Get user profile information
            $oauth2 = new Google_Service_Oauth2($this->client);
            $user_info = $oauth2->userinfo->get();
            
            return array(
                'google_id' => $user_info->id,
                'email' => $user_info->email,
                'first_name' => $user_info->givenName,
                'last_name' => $user_info->familyName,
                'full_name' => $user_info->name,
                'profile_picture' => $user_info->picture
            );
            
        } catch (Exception $e) {
            log_message('error', 'Google OAuth Error: ' . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Check if user exists in database by email
     */
    public function find_user_by_email($email) {
        return $this->CI->db->get_where('users', array('email' => $email))->row();
    }
    
    /**
     * Create new user from Google OAuth data
     */
    public function create_user($google_data) {
        $user_data = array(
            'first_name' => $google_data['first_name'],
            'last_name' => $google_data['last_name'],
            'email' => $google_data['email'],
            'password' => '', // No password for OAuth users
            'user_type' => 'student', // Default to student
            'status' => 1, // Active
            'date_added' => time(),
            'google_id' => $google_data['google_id'],
            'profile_picture' => $google_data['profile_picture']
        );
        
        $this->CI->db->insert('users', $user_data);
        return $this->CI->db->insert_id();
    }
    
    /**
     * Update existing user with Google ID
     */
    public function link_google_account($user_id, $google_id) {
        $this->CI->db->where('id', $user_id);
        $this->CI->db->update('users', array('google_id' => $google_id));
    }
}
